import 'dart:developer';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter/services.dart';

import '../../api/client/common/file_api.dart';
import '../../api/client/common/multipart_api.dart';
import '../../config/file_config.dart';
import '../../config/global.dart';
import '../../domain/task/enum/upload.dart';
import '../../domain/task/multipart_upload_task.dart';
import '../../domain/task/single_upload_task.dart';
import '../../util/file_util.dart';

class MultipartUploadService {
  static Future<void> doUploadFile({
    //上传任务
    required MultipartUploadTask task,
    //上传出错
    required Function(MultipartUploadTask) onError,
    //上传成功
    required Function(MultipartUploadTask) onSuccess,
    //上传中更新状态
    required Function(MultipartUploadTask) onUpload,
    //上传开始后
    required Function(Isolate) onAfterStart,
    ReceivePort? receivePort,
  }) async {
    receivePort ??= ReceivePort();

    RootIsolateToken rootIsolateToken = RootIsolateToken.instance!;
    receivePort.listen(
          (msg) async {
        if (msg is SendPort) {
          //传递初始值
          msg.send([1, task.toJson()]);
          msg.send([2, Global.user, Global.database!]);
          msg.send([3, rootIsolateToken]);
          msg.send(null);
          //获取发送器
        } else if (msg is List) {
          //上传中消息
          switch (msg[0]) {
            case 1: //task
              task.copy(MultipartUploadTask.fromJson(msg[1]));
              await onUpload(task);
              break;
          }
        } else if (msg is FormatException) {
          //上传出现异常
          task.status = UploadTaskStatus.error;
          task.statusMessage = msg.message;
          await onError(task);
          receivePort!.close();
        } else if (msg == true) {
          //上传结束
          task.status = UploadTaskStatus.finished;
          await onSuccess(task);
          receivePort!.close();
        }
      },
    );

    var isolate = await Isolate.spawn(MultipartUploadService._startUploadIsolate, receivePort.sendPort);
    isolate.addOnExitListener(receivePort.sendPort);
    await onAfterStart(isolate);
  }

  //用于组合初始化、上传、完成上传方法和初始化isolate环境
  //其他队列->上传队列（uploading）->传入方法->初始化->上传->完成上传->结束方法->完成队列
  //该方法内不应该存在更改status的情况，因为status的更改会伴随着状态的改变
  // 接收消息格式
  // 1:task
  // 2:user、db
  // 3:rootIsolateToken
  // true:结束
  // 发送消息格式
  // sendPort，通过类型识别即可
  // 1:task
  static Future<void> _startUploadIsolate(SendPort sendPort) async {
    try {
      var receivePort = ReceivePort();
      //发送sendPort
      sendPort.send(receivePort.sendPort);

      log("上传线程开始执行...");
      //任务
      late MultipartUploadTask task;
      //等待主isolate发送消息并根据消息设置当前isolate环境，配置环境是必须的，所以这里采用阻塞的方式
      await for (var msg in receivePort) {
        if (msg == null) {
          //退出
          break;
        } else if (msg is List) {
          switch (msg[0]) {
            case 1: //获取状态，用于之后修改状态和发送最新状态
              task = MultipartUploadTask.fromJson(msg[1]);
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
      await _initMultipartUpload(task, sendPort);
      log("初始化完成");
      //进行上传
      //上传分片过程中要将任务持久化到数据库
      log("上传中...");
      await _doMultipartUpload(task, sendPort);
      log("上传完成");
      //完成上传
      log("合并中...");
      await _completeMultipartUpload(task, sendPort);
      log("合并完成");
      sendPort.send(true);
    } catch (e) {
      if (e is FormatException) {
        sendPort.send(e);
      } else {
        sendPort.send(const FormatException("请重新上传"));
      }
    } finally {
      //清理资源
      // Global.close();
    }
  }

  static Future<void> _initMultipartUpload(
      MultipartUploadTask task,
      SendPort sendPort,
      ) async {
    RandomAccessFile? read;

    try {
      final file = File(task.srcPath!);
      var fileStat = await file.stat();

      //验证文件
      if (fileStat.size >= FileConfig.maxUploadFileSize) throw const FormatException("文件大小超出限制");

      read = await file.open();
      var data = await read.read(16);
      task.magicNumber = data;

      if (task.md5 != null) {
        //已经解析过文件了，不需要再计算md5
        //初始化阶段
        task.statusMessage = "恢复上传";
        task.status = UploadTaskStatus.init;
        sendPort.send([1, task.toJson()]);

        //校验是否和原文件一致
        if (task.totalSize != fileStat.size) throw const FormatException("文件与源文件不一致");
      } else {
        //初始化阶段
        task.statusMessage = "解析文件";
        task.createTime = DateTime.now();
        task.totalSize = fileStat.size;
        sendPort.send([1, task.toJson()]);
        //计算md5
        var md5 = await FileUtil.getFileChecksum(file);
        if (md5 == null) {
          return;
        }
        task.md5 = md5;
      }

      task.statusMessage = "初始化上传";
      sendPort.send([1, task.toJson()]);

      //初始化上传
      var multipartInfo = await MultipartApi.initMultipartUpload(task.md5!, fileStat.size, task.magicNumber!);

      task.uploadedSize = (multipartInfo.uploadedPartNum ?? 0) * multipartInfo.partSize!;
      task.fileId = multipartInfo.fileId;
    } catch (e) {
      rethrow;
    } finally {
      read?.close();
    }
  }

  static Future<void> _doMultipartUpload(MultipartUploadTask task, SendPort sendPort) async {
    task.statusMessage = "正在上传";
    task.status = UploadTaskStatus.uploading;
    sendPort.send([1, task.toJson()]);

    RandomAccessFile? access;
    try {
      //打开文件
      final file = File(task.srcPath!);
      access = await file.open();
      //获取上传url和上传任务状态
      var (multipartInfo, urlList) = await MultipartApi.getUploadUrl(task.fileId!, Global.urlCount, 0);
      //已上传的大小
      int uploadedPartNum = multipartInfo.uploadedPartNum ?? 0;
      //缓冲区
      List<int> buffer = List<int>.filled(multipartInfo.partSize!, 0);
      //开始上传
      while (uploadedPartNum < multipartInfo.totalPartNum!) {
        //设置起始位置，第一个分片起始位置为0，第二个为partSize，依此类推
        access.setPositionSync((multipartInfo.uploadedPartNum ?? 0) * multipartInfo.partSize!);
        for (var url in urlList) {
          //读取数据
          var len = await access.readInto(buffer);
          var preUploadedSize = task.uploadedSize;
          //上传
          if (len < buffer.length) {
            //读取到最后一个
            await FileUtil.uploadFile(
              url,
              buffer.sublist(0, len),
              onUpload: (count, total) {
                if (count % (1024 * 1024) == 0) {
                  task.uploadedSize = preUploadedSize+count;
                  sendPort.send([1, task.toJson()]);
                }
              },
            );
          } else {
            await FileUtil.uploadFile(
              url,
              buffer,
              onUpload: (count, total) {
                if (count % (1024 * 1024) == 0) {
                  task.uploadedSize = preUploadedSize+count;
                  sendPort.send([1, task.toJson()]);
                }
              },
            );
          }
          //用于通知已上传分片数
          uploadedPartNum++;
        }
        //获取url和上传任务状态
        (multipartInfo, urlList) = await MultipartApi.getUploadUrl(task.fileId!, Global.urlCount, uploadedPartNum);
        //更新已上传分片数
        uploadedPartNum = multipartInfo.uploadedPartNum ?? 0;
      }
    } catch (e) {
      rethrow;
    } finally {
      if (access != null) {
        access.close();
      }
    }
  }

  static Future<void> _completeMultipartUpload(MultipartUploadTask task, SendPort sendPort) async {
    task.statusMessage = "整合中";
    sendPort.send([1, task.toJson()]);

    await MultipartApi.completeMultipartUpload(task.fileId!);

    task.statusMessage = "上传完毕";
    task.status = UploadTaskStatus.finished;
    sendPort.send([1, task.toJson()]);
  }
}

class SingleUploadService {
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

    var isolate = await Isolate.spawn(SingleUploadService._startUploadIsolate, receivePort.sendPort);
    isolate.addOnExitListener(receivePort.sendPort);
    onAfterStart(isolate);
  }

  static Future<void> _startUploadIsolate(SendPort sendPort) async {
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

      //计算md5
      var md5 = await FileUtil.getFileChecksum(file);
      if (md5 == null) {
        return;
      }
      task.md5 = md5;
      task.status = UploadTaskStatus.uploading;
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
          onUpload: (count, total) {
            if (count % (1024 * 1024) == 0) {
              task.uploadedSize = count;
              task.totalSize = total;
              sendPort.send([1, task.toJson()]);
            }
          },
        );

        await FileApi.completePutFile(fileId);
      }

      task.status = UploadTaskStatus.finished;
      sendPort.send(true);
    } catch (e) {
      rethrow;
    } finally {}
  }
}
