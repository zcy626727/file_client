import 'dart:developer';
import 'dart:isolate';

import 'package:file_client/service/file/user_file_service.dart';
import 'package:file_client/service/team/space_file_service.dart';
import 'package:flutter/cupertino.dart';

import '../common/file/constant/upload.dart';
import '../common/file/service/upload_service.dart';
import '../common/file/task/multipart_upload_task.dart';
import '../config/file_config.dart';
import '../config/global.dart';
import '../domain/upload_notion.dart';

//维护全局传输任务列表
class UploadState extends ChangeNotifier {
  //上传队列
  List<MultipartUploadTask> uploadingTaskList = [];
  Map<MultipartUploadTask, Isolate> uploadingIsolateMap = {};

  //上传等待队列，自动开始
  List<MultipartUploadTask> awaitingTaskList = [];

  //暂停队列
  List<MultipartUploadTask> pauseTaskList = [];

  //出错任务
  List<MultipartUploadTask> errorTaskList = [];

  //已完成任务
  List<MultipartUploadTask> finishedTaskList = [];

  //通知
  List<UploadNotion> uploadNotionList = [];

  //totalList
  List<MultipartUploadTask> totalTaskList = [];

  //发送上传提示，上传开始和上传完成
  void sendUploadNotion(UploadNotion notion) {
    uploadNotionList.add(notion);
    notifyListeners();
  }

  int get currentUploadTaskCount {
    return uploadingTaskList.length;
  }

  // 删除列表，停止所有上传任务
  void clearUploadTask() {
    for (var task in uploadingTaskList) {
      var iso = uploadingIsolateMap.remove(task);
      if (iso != null) {
        iso.kill();
      }
    }
    uploadingTaskList = <MultipartUploadTask>[];
    awaitingTaskList = <MultipartUploadTask>[];
    pauseTaskList = <MultipartUploadTask>[];
    errorTaskList = <MultipartUploadTask>[];
    finishedTaskList = <MultipartUploadTask>[];
    totalTaskList = <MultipartUploadTask>[];
    uploadNotionList = <UploadNotion>[];
  }

  void initUploadTask() async {
    totalTaskList = await Global.uploadTaskProvider.getAllTaskList();
    for (var task in totalTaskList) {
      if (task.status == UploadTaskStatus.finished) {
        finishedTaskList.add(task);
      } else if (task.status == UploadTaskStatus.error) {
        errorTaskList.add(task);
      } else {
        task.status = UploadTaskStatus.pause;
        pauseTaskList.add(task);
      }
    }
  }

  //新建任务
  //新任务->等待队列/上传队列
  void addUploadTask(MultipartUploadTask task) async {
    totalTaskList.add(task);
    if (uploadingTaskList.length > FileConfig.uploadParallelNumber) {
      log("上传任务过多,加到入等待队列");
      task.status = UploadTaskStatus.awaiting;
      awaitingTaskList.add(task);
      notifyListeners();
      //持久化任务
      await Global.uploadTaskProvider.insertOrUpdate(task);
    } else {
      log("加到入上传队列");
      task.status = UploadTaskStatus.uploading;
      task.statusMessage = "初始化";
      uploadingTaskList.add(task);
      notifyListeners();
      await doUpload(task);
    }
  }

  //等待队列/上传队列->暂停队列
  void pauseUploadTask(MultipartUploadTask task) {
    if (uploadingTaskList.remove(task)) {
      task.status = UploadTaskStatus.pause;
      pauseTaskList.add(task);
      var isolate = uploadingIsolateMap.remove(task);
      assert(isolate != null, "上传文件的isolate一定存在于uploadingIsolateMap中");
      isolate!.kill();
    }
    notifyListeners();
  }

  //暂停队列->等待队列/上传队列
  void startPauseTask(MultipartUploadTask task) async {
    if (pauseTaskList.remove(task)) {
      if (uploadingTaskList.length <= FileConfig.uploadParallelNumber) {
        //上传队列有位置，加进去并执行
        task.status = UploadTaskStatus.uploading;
        uploadingTaskList.add(task);
        await doUpload(task);
      } else {
        //加入到等待队列
        task.status = UploadTaskStatus.awaiting;
        awaitingTaskList.add(task);
      }
      notifyListeners();
      startNextUploadTask();
    }
  }

  //删除任务（所有队列都包括）
  void removeUploadTask(MultipartUploadTask task) async {
    if (task.status == UploadTaskStatus.uploading) {
      //移除并杀死
      uploadingTaskList.remove(task);
      var isolate = uploadingIsolateMap.remove(task);
      assert(isolate != null, "上传文件的isolate一定存在于uploadingIsolateMap中");
      isolate!.kill();
    } else if (task.status == UploadTaskStatus.awaiting) {
      awaitingTaskList.remove(task);
    } else if (task.status == UploadTaskStatus.pause) {
      pauseTaskList.remove(task);
    } else if (task.status == UploadTaskStatus.error) {
      errorTaskList.remove(task);
    } else if (task.status == UploadTaskStatus.finished) {
      finishedTaskList.remove(task);
    }
    totalTaskList.remove(task);
    await Global.uploadTaskProvider.delete(task);
    notifyListeners();
  }

  //等待队列->上传队列
  void startNextUploadTask() async {
    if (uploadingTaskList.length > FileConfig.uploadParallelNumber || awaitingTaskList.isEmpty) {
      return;
    }
    //等待队列取出一个任务放到上传队列
    var task = awaitingTaskList.removeAt(0);
    task.status = UploadTaskStatus.uploading;
    uploadingTaskList.add(task);
    await doUpload(task);
    notifyListeners();
  }

  Future<void> doUpload(MultipartUploadTask task) async {
    MultipartUploadService.doUploadFile(
      task: task,
      onError: (task) async {
        //从上传队列移除
        uploadingTaskList.remove(task);
        //从上传map移除
        uploadingIsolateMap.remove(task);
        //加入到错误队列
        errorTaskList.add(task);
        //持久化
        await Global.uploadTaskProvider.insertOrUpdate(task);
        notifyListeners();
      },
      onSuccess: (_) async {
        //上传结束
        task.status = UploadTaskStatus.finished;
        //从上传队列移除
        uploadingTaskList.remove(task);
        //从上传map移除
        uploadingIsolateMap.remove(task);
        //加入到完成队列
        finishedTaskList.add(task);
        //持久化
        await Global.uploadTaskProvider.insertOrUpdate(task);

        // 创建文件
        switch (task.targetType) {
          case UploadTaskTargetType.user:
            await UserFileService.createFile(filename: task.fileName!, fileId: task.fileId!, parentId: task.parentId!);
          case UploadTaskTargetType.space:
            await SpaceFileService.createFile(filename: task.fileName!, fileId: task.fileId!, parentId: task.parentId!, spaceId: task.spaceId!);
        }

        notifyListeners();
        //开始下一个任务
        startNextUploadTask();
      },
      onUpload: (newTask) async {
        task.copy(newTask);
        notifyListeners();
        log("${newTask.uploadedSize}/${newTask.totalSize}");
      },
      onAfterStart: (isolate) {
        //加入map
        uploadingIsolateMap[task] = isolate;
      },
    );
  }
}
