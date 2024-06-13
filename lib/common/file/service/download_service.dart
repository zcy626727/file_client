import 'dart:developer';
import 'dart:io';
import 'dart:isolate';

import 'package:file_client/service/file/user_file_service.dart';
import 'package:file_client/service/team/space_file_service.dart';
import 'package:flutter/services.dart';

import '../../../config/global.dart';
import '../../../util/file_util.dart';
import '../constant/download.dart';
import '../task/download_task.dart';

class DownloadService {
  static Future<void> doDownloadFile({
    //下载任务
    required DownloadTask task,
    //下载出错
    required Function(DownloadTask) onError,
    //下载成功
    required Function(DownloadTask) onSuccess,
    //下载中更新状态
    required Function(DownloadTask) onDownloading,
    //下载开始后
    required Function(Isolate) onAfterStart,
    ReceivePort? receivePort,
  }) async {
    //消息接收器
    receivePort ??= ReceivePort();
    RootIsolateToken rootIsolateToken = RootIsolateToken.instance!;

    receivePort.listen(
          (msg) async {
        if (msg is SendPort) {
          msg.send([1, task.toJson()]);
          msg.send([2, Global.user, Global.database!]);
          msg.send([3, rootIsolateToken]);
          //表示结束
          msg.send(null);
          //获取发送器
        } else if (msg is List) {
          //过程消息
          switch (msg[0]) {
            case 1: //task
              task.copy(DownloadTask.fromJson(msg[1]));
              await onDownloading(task);
              break;
          }
        } else if (msg is FormatException) {
          //上传出现异常
          task.status = DownloadTaskStatus.error;
          task.statusMessage = msg.message;
          await onError(task);
          receivePort!.close();
        } else if (msg == true) {
          //上传结束
          task.status = DownloadTaskStatus.finished;
          receivePort!.close();
          await onSuccess(task);
        }
      },
    );

    var isolate = await Isolate.spawn(DownloadService.startIsolate, receivePort.sendPort);
    isolate.addOnExitListener(receivePort.sendPort);
    await onAfterStart(isolate);
  }

  static Future<void> startIsolate(SendPort sendPort) async {
    try {
      var receivePort = ReceivePort();
      //发送sendPort
      sendPort.send(receivePort.sendPort);

      log("下载线程开始执行...");
      //任务
      late DownloadTask task;
      //等待主isolate发送消息并根据消息设置当前isolate环境，配置环境是必须的，所以这里采用阻塞的方式
      await for (var msg in receivePort) {
        if (msg == null) {
          //退出
          break;
        } else if (msg is List) {
          switch (msg[0]) {
            case 1: //获取状态，用于之后修改状态和发送最新状态
              task = DownloadTask.fromJson(msg[1]);
              break;
            case 2: //复制主线程环境：数据库、用户信息
              Global.copyEnv(msg[1], msg[2]);
              break;
            case 3:
              //调用数据库等操作必须初始化
              BackgroundIsolateBinaryMessenger.ensureInitialized(msg[1]);
          }
        }
      }
      log("环境配置完成");

      //队列转换
      //文件上传时通过task发送任务信息，用于更新任务信息
      //初始化，确保文件计算好md5、后台初创建了上传任务
      log("初始化...");
      await initDownload(task, sendPort);
      log("初始化完成");
      //进行上传
      //上传分片过程中要将任务持久化到数据库
      log("下载中...");
      await doDownload(task, sendPort);
      log("下载完成");
      sendPort.send(true);
    } catch (e) {
      if (e is FormatException) {
        sendPort.send(e);
      } else {
        sendPort.send(const FormatException("请重新下载"));
      }
      rethrow;
    } finally {
      //清理资源
      // Global.close();
    }
  }

  static Future<void> initDownload(DownloadTask task, SendPort sendPort) async {
    //路径格式
    if (!task.targetPath!.endsWith('/')) {
      task.targetPath = "${task.targetPath}/";
    }
    //文件没下载或下载出现问题，需要重新下载
    if (task.downloadedSize > 0 && File("${task.targetPath}${task.targetName}").existsSync()) {
      //已下载了一部分
      task.statusMessage = "正在恢复下载";
    } else {
      task.statusMessage = "初始化下载";
      //需要获取正确的可用文件名，同时创建文件
      task.targetName = await FileUtil.getValidFileName(task.targetName!, task.targetPath!);
      //创建文件，先占位置
      await File("${task.targetPath}${task.targetName}").create();
    }
    await Global.downloadTaskProvider.insertOrUpdate(task);
    sendPort.send([1, task.toJson()]);

    switch (task.type) {
      case DownloadTaskType.space:
        var url = await SpaceFileService.getDownloadUrl(spaceFileId: task.spaceFileId!);
        task.downloadUrl = url;
        break;
      case DownloadTaskType.user:
        var url = await UserFileService.getDownloadUrl(userFileId: task.userFileId!);
        task.downloadUrl = url;
        break;
      default:
        throw const FormatException("不支持的文件类型");
    }
  }

  static Future<void> doDownload(DownloadTask task, SendPort sendPort) async {
    var savePath = "${task.targetPath}${task.targetName}";
    var file = File("${task.targetPath}${task.targetName}");
    var fileStat = file.statSync();
    task.statusMessage = "下载中";
    task.status = DownloadTaskStatus.downloading;
    sendPort.send([1, task.toJson()]);
    int targetDownloadSize = 0;
    task.downloadedSize = fileStat.size;

    //上传并返回进度
    await FileUtil.downloadFile(
      task.downloadUrl!,
      savePath,
      callback: (received) async {
        if (received > targetDownloadSize) {
          targetDownloadSize = received + 1024 * 1024;
          task.downloadedSize = received;
          await Global.downloadTaskProvider.insertOrUpdate(task);
          sendPort.send([1, task.toJson()]);
        }
      },
    );

    task.downloadedSize = task.totalSize!;
    await Global.downloadTaskProvider.insertOrUpdate(task);
    task.statusMessage = "下载完成";
    task.status = DownloadTaskStatus.finished;
    sendPort.send([1, task.toJson()]);
  }
}
