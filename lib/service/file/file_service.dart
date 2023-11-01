import 'dart:io';
import 'dart:isolate';

import 'package:file_client/api/client/file/file_api.dart';
import 'package:flutter/services.dart';

import '../../config/global.dart';
import '../../domain/task/enum/upload.dart';
import '../../domain/task/single_upload_task.dart';
import '../../util/file_util.dart';

// var (getUrl, staticUrl) = await FileApi.genGetFileUrl(task.fileId!);
// task.getUrl = getUrl;
// task.staticUrl = staticUrl;
// sendPort.send([1, task.toJson()]);

class FileService {
  static Future<void> doUploadFile({
    //上传任务
    required SingleUploadTask task,
    //上传出错
    required Function(SingleUploadTask) onError,
    //上传成功
    required Function(SingleUploadTask) onSuccess,
    //上传中更新状态
    required Function(SingleUploadTask) onUpload,
    //上传开始后
    required Function(Isolate) onAfterStart,
    ReceivePort? receivePort,
  }) async {
    receivePort ??= ReceivePort();

    RootIsolateToken rootIsolateToken = RootIsolateToken.instance!;
    receivePort.listen(
          (msg) async {
        if (msg is SendPort) {
          msg.send([1, task.toJson()]);
          msg.send([2, Global.user, Global.database!]);
          msg.send([3, rootIsolateToken]);
          msg.send(null);
          //获取发送器
        } else if (msg is List) {
          //过程消息
          switch (msg[0]) {
            case 1: //task
              task.copy(SingleUploadTask.fromJson(msg[1]));
              await onUpload(task);
              break;
          }
        } else if (msg is FormatException) {
          //上传出现异常
          task.status = UploadTaskStatus.error;
          task.statusMessage = msg.message;
          await onError(task);
        } else if (msg == true) {
          //上传结束
          task.status = UploadTaskStatus.finished;
          await onSuccess(task);
        }
      },
    );

    var isolate = await Isolate.spawn(FileService.startUploadIsolate, receivePort.sendPort);
    isolate.addOnExitListener(receivePort.sendPort);
    onAfterStart(isolate);
  }

  static Future<void> startUploadIsolate(SendPort sendPort) async {
    var receivePort = ReceivePort();
    //发送sendPort
    sendPort.send(receivePort.sendPort);
    //任务
    late SingleUploadTask task;
    //交换数据，初始化
    await for (var msg in receivePort) {
      if (msg == null) {
        //退出
        break;
      } else if (msg is List) {
        switch (msg[0]) {
          case 1: //获取状态，用于之后修改状态和发送最新状态
            task = SingleUploadTask.fromJson(msg[1]);
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

    RandomAccessFile? read;
    try {
      //读取文件
      final file = File(task.srcPath!);
      read = await file.open();
      var data = await read.read(16);

      task.status = UploadTaskStatus.init;

      //计算md5
      var md5 = await FileUtil.getFileChecksum(file);
      if (md5 == null) {
        return;
      }
      task.md5 = md5;
      sendPort.send([1, task.toJson()]);

      //获取文件上传链接
      var (putUrl, fileId) = await FileApi.genPutFileUrl(md5, task.private ?? true, data);
      task.fileId = fileId;
      sendPort.send([1, task.toJson()]);

      if (putUrl.isNotEmpty) {
        var data = await file.readAsBytes();
        //上传文件
        await FileUtil.uploadFile(
          putUrl,
          data,
          // onUpload: (count, total) {
          //   task.uploadedSize = count;
          //   task.totalSize = total;
          //   sendPort.send([1, task.toJson()]);
          // },
        );

        await FileApi.completePutFile(fileId);
      }
      sendPort.send(true);
    } catch (e) {
      rethrow;
    } finally {}
  }

  static Future<(String, String)> genGetFileUrl(int fileId) async {
    var t = await FileApi.genGetFileUrl(fileId);
    return t;
  }

  static Future<(String, int)> genPutFileUrl(
      String md5,
      bool isPrivate,
      List<int> magicNumber,
      ) async {
    return await FileApi.genPutFileUrl(md5, isPrivate, magicNumber);
  }
}