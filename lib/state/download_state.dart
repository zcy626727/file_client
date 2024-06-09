import 'dart:developer';
import 'dart:isolate';

import 'package:flutter/cupertino.dart';

import '../common/file/constant/download.dart';
import '../common/file/service/download_service.dart';
import '../common/file/task/download_task.dart';
import '../config/file_config.dart';
import '../config/global.dart';

class DownloadState extends ChangeNotifier {
  //下载队列
  List<DownloadTask> downloadingTaskList = [];
  Map<DownloadTask, Isolate> downloadIsolateMap = {};

  //上传等待队列，自动开始
  List<DownloadTask> awaitingTaskList = [];

  //暂停队列
  List<DownloadTask> pauseTaskList = [];

  //出错任务
  List<DownloadTask> errorTaskList = [];

  //已完成任务
  List<DownloadTask> finishedTaskList = [];

  //totalList
  List<DownloadTask> totalTaskList = [];

  void initDownloadTask() async {
    totalTaskList = await Global.downloadTaskProvider.getAllTaskList();
    for (var task in totalTaskList) {
      if (task.status == DownloadTaskStatus.finished) {
        finishedTaskList.add(task);
      } else if (task.status == DownloadTaskStatus.error) {
        errorTaskList.add(task);
      } else {
        task.status = DownloadTaskStatus.pause;
        pauseTaskList.add(task);
      }
    }
  }

  void clearDownloadTask() {
    for (var task in downloadingTaskList) {
      var iso = downloadIsolateMap.remove(task);
      if (iso != null) {
        iso.kill();
      }
    }
    downloadingTaskList = <DownloadTask>[];
    awaitingTaskList = <DownloadTask>[];
    pauseTaskList = <DownloadTask>[];
    errorTaskList = <DownloadTask>[];
    finishedTaskList = <DownloadTask>[];
    totalTaskList = <DownloadTask>[];
  }

  //新建任务
  //新任务->等待队列/下载队列
  void addDownloadTask(DownloadTask task) async {
    totalTaskList.add(task);
    if (downloadingTaskList.length > FileConfig.downloadParallelNumber) {
      log("下载任务过多,加到入等待队列");
      task.status = DownloadTaskStatus.awaiting;
      awaitingTaskList.add(task);
      notifyListeners();
      //持久化任务
      await Global.downloadTaskProvider.insertOrUpdate(task);
    } else {
      log("加到入上传队列");
      task.status = DownloadTaskStatus.downloading;
      task.statusMessage = "初始化";
      downloadingTaskList.add(task);
      notifyListeners();
      await doDownload(task);
    }
  }

  //等待队列/上传队列->暂停队列
  void pauseDownloadTask(DownloadTask task) {
    if (downloadingTaskList.remove(task)) {
      task.status = DownloadTaskStatus.pause;
      pauseTaskList.add(task);
      var isolate = downloadIsolateMap.remove(task);
      assert(isolate != null, "上传文件的isolate一定存在于uploadingIsolateMap中");
      isolate!.kill();
    }
    notifyListeners();
  }

  //暂停队列->等待队列/上传队列
  void startPauseTask(DownloadTask task) async {
    if (pauseTaskList.remove(task)) {
      if (downloadingTaskList.length <= FileConfig.uploadParallelNumber) {
        //上传队列有位置，加进去并执行
        task.status = DownloadTaskStatus.downloading;
        downloadingTaskList.add(task);
        await doDownload(task);
      } else {
        //加入到等待队列
        task.status = DownloadTaskStatus.awaiting;
        awaitingTaskList.add(task);
      }
      notifyListeners();
      startNextDownloadTask();
    }
  }

  //删除任务（所有队列都包括）
  void removeDownloadTask(DownloadTask task) async {
    if (task.status == DownloadTaskStatus.downloading) {
      //移除并杀死
      downloadingTaskList.remove(task);
      var isolate = downloadIsolateMap.remove(task);
      assert(isolate != null, "上传文件的isolate一定存在于uploadingIsolateMap中");
      isolate!.kill();
    } else if (task.status == DownloadTaskStatus.awaiting) {
      awaitingTaskList.remove(task);
    } else if (task.status == DownloadTaskStatus.pause) {
      pauseTaskList.remove(task);
    } else if (task.status == DownloadTaskStatus.error) {
      errorTaskList.remove(task);
    } else if (task.status == DownloadTaskStatus.finished) {
      finishedTaskList.remove(task);
    }
    totalTaskList.remove(task);
    await Global.downloadTaskProvider.delete(task);
    notifyListeners();
  }

  //等待队列->上传队列
  void startNextDownloadTask() async {
    if (downloadingTaskList.length > FileConfig.uploadParallelNumber ||
        awaitingTaskList.isEmpty) {
      return;
    }
    //等待队列取出一个任务放到上传队列
    var task = awaitingTaskList.removeAt(0);
    task.status = DownloadTaskStatus.downloading;
    downloadingTaskList.add(task);
    await doDownload(task);
    notifyListeners();
  }

  Future<void> doDownload(DownloadTask task) async {

    await DownloadService.doDownloadFile(
      task: task,
      onError: (newTask) async {
        //上传出现异常
        task.copy(newTask);
        //从上传队列移除
        downloadingTaskList.remove(task);
        //从上传map移除
        downloadIsolateMap.remove(task);
        //加入到错误队列
        errorTaskList.add(task);
        //持久化
        await Global.downloadTaskProvider.insertOrUpdate(task);
        notifyListeners();
      },
      onSuccess: (_) async {
        //上传结束
        task.status = DownloadTaskStatus.finished;
        //从上传队列移除
        downloadingTaskList.remove(task);
        //从上传map移除
        downloadIsolateMap.remove(task);
        //加入到完成队列
        finishedTaskList.add(task);
        //持久化
        await Global.downloadTaskProvider.insertOrUpdate(task);
        notifyListeners();
        //开始下一个任务
        startNextDownloadTask();
      },
      onDownloading: (newTask) async {
        task.copy(newTask);
        notifyListeners();
        log("更新上传状态");
      },
      onAfterStart: (isolate) {
        downloadIsolateMap[task] = isolate;
      },
    );

    // //消息接收器
    // var receivePort = ReceivePort();
    // RootIsolateToken rootIsolateToken = RootIsolateToken.instance!;
    // receivePort.listen(
    //   (msg) async {
    //     if (msg is SendPort) {
    //       msg.send([1, task.toJson()]);
    //       msg.send([2, Global.user, Global.database!]);
    //       msg.send([3, rootIsolateToken]);
    //       //表示结束
    //       msg.send(null);
    //       //获取发送器
    //     } else if (msg is List) {
    //       //过程消息
    //       switch (msg[0]) {
    //         case 1: //task
    //
    //           break;
    //       }
    //     } else if (msg is FormatException) {
    //
    //     } else if (msg == true) {
    //
    //     }
    //   },
    // );
    //
    // var isolate = await Isolate.spawn(DownloadService.startIsolate, receivePort.sendPort);
    // isolate.addOnExitListener(receivePort.sendPort);
    // //加入map
  }
}
