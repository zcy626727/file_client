import 'dart:developer';

import 'package:file_client/common/file/constant/download.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sqflite/sqflite.dart';

import '../../../config/global.dart';

part 'download_task.g.dart';

@JsonSerializable()
class DownloadTask {
  int? id;

  // userFile
  int? userId;
  int? userFileId; //用户的文件URL
  // spaceFile
  int? spaceId;
  int? spaceFileId;

  // task类型：user/space
  int? type;

  //文件目标位置和文件名
  String? targetPath;
  String? targetName;

  //下载源文件的地址
  String? downloadUrl; //下载源文件地址
  int? totalSize; //总大小
  int downloadedSize; //已下载大小，只用来显示，下载进度以真实文件大小为主
  String? statusMessage;
  int? status;
  DateTime? createTime;

  static String createSql = '''
    create table downloadTask ( 
      id integer primary key autoincrement, 
      userId integer, 
      userFileId integer, 
      targetPath text not null,
      targetName text not null,
      downloadUrl text,      
      totalSize integer,
      spaceId integer,
      spaceFileId integer,
      type integer,
      downloadedSize integer not null,
      statusMessage text not null,
      status integer not null,
      createTime text not null
    )
  ''';

  void copy(DownloadTask task) {
    id = task.id;
    userId = task.userId;
    userFileId = task.userFileId;
    targetPath = task.targetPath;
    targetName = task.targetName;
    downloadUrl = task.downloadUrl;
    totalSize = task.totalSize;
    downloadedSize = task.downloadedSize;
    statusMessage = task.statusMessage;
    status = task.status;
    createTime = task.createTime;
  }

  factory DownloadTask.fromJson(Map<String, dynamic> json) => _$DownloadTaskFromJson(json);

  Map<String, dynamic> toJson() => _$DownloadTaskToJson(this);

  DownloadTask() : downloadedSize = 0;

  DownloadTask.userFile({
    this.userFileId,
    this.userId,
    this.targetPath,
    this.targetName,
    this.downloadUrl,
    this.totalSize,
    this.downloadedSize = 0,
    this.statusMessage,
    this.status,
  }) {
    createTime = DateTime.now();
    type = DownloadTaskType.user;
  }

  DownloadTask.spaceFile({
    this.spaceFileId,
    this.spaceId,
    this.targetPath,
    this.targetName,
    this.downloadUrl,
    this.totalSize,
    this.downloadedSize = 0,
    this.statusMessage,
    this.status,
  }) {
    createTime = DateTime.now();
    type = DownloadTaskType.space;
  }
}

class DownloadTaskProvider {
  late Database db;

  Future<DownloadTask> insertOrUpdate(DownloadTask task) async {
    task.id = await db.insert(
      "downloadTask",
      task.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return task;
  }

  Future<void> delete(DownloadTask task) async {
    if (task.id == null) {
      log('task.id为null');
      return;
    }
    task.id = await db.delete(
      "downloadTask",
      where: "id=?",
      whereArgs: [task.id],
    );
  }

  Future<List<DownloadTask>> getAllTaskList() async {
    var user = Global.user;
    if (user.id == null || user.id == 0) {
      return <DownloadTask>[];
    }
    List<Map<String, Object?>> mapList = await db.query(
      "downloadTask",
      where: "userId=?",
      whereArgs: [user.id],
      orderBy: "createTime",
    );
    List<DownloadTask> list = [];
    for (var map in mapList) {
      list.add(DownloadTask.fromJson(map));
    }
    return list;
  }
}
