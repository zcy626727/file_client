import 'dart:developer';

import 'package:json_annotation/json_annotation.dart';
import 'package:sqflite/sqflite.dart';

import '../../../config/global.dart';
import '../constant/upload.dart';

part 'multipart_upload_task.g.dart';

/// 上传任务
/// 文件：每个任务代表一个文件，上传结束后根据类型调用方法添加userFile或spaceFile
/// 文件夹：用一个文件任务列表表示，先按照路径顺序创建文件夹，然后再初始化parentId属性，最后上传文件后创建useFile/spaceFile即可
@JsonSerializable()
class MultipartUploadTask {
  int? id;
  String? fileName; //文件名
  String? srcPath; //文件原路径
  int? totalSize; //文件/文件夹下的文件的大小
  int uploadedSize = 0; //进度
  String? md5; //文件的MD5，文件夹为0
  int? status; //上传状态
  String? statusMessage; //状态
  DateTime? createTime;
  int? fileId;
  bool? private;
  int? mediaType;

  @JsonKey(includeFromJson: false, includeToJson: false)
  List<int>? magicNumber;

  //额外业务信息
  int? parentId; //上传状态
  int? userId;
  int? targetType; //上传目标位置,user/space

  //space
  int? spaceId;

  MultipartUploadTask();

  MultipartUploadTask.userFile({
    required this.srcPath,
    this.parentId,
    this.fileName,
    this.userId,
    this.private,
    this.status = UploadTaskStatus.uploading,
    this.uploadedSize = 0,
    this.targetType = UploadTaskTargetType.user,
  });

  MultipartUploadTask.spaceFile({
    required this.srcPath,
    this.parentId,
    this.fileName,
    this.spaceId,
    this.status = UploadTaskStatus.uploading,
    this.uploadedSize = 0,
    this.targetType = UploadTaskTargetType.space,
  });

  void copy(MultipartUploadTask task) {
    id = task.id;
    fileName = task.fileName;
    srcPath = task.srcPath;
    parentId = task.parentId;
    uploadedSize = task.uploadedSize;
    totalSize = task.totalSize;
    status = task.status;
    createTime = task.createTime;
    statusMessage = task.statusMessage;
    md5 = task.md5;
    fileId = task.fileId;
    magicNumber = task.magicNumber;
    parentId = task.parentId;
    private = task.private;
    mediaType=task.mediaType;
  }

  factory MultipartUploadTask.fromJson(Map<String, dynamic> json) => _$MultipartUploadTaskFromJson(json);

  Map<String, dynamic> toJson() => _$MultipartUploadTaskToJson(this);
}

class UploadTaskProvider {
  late Database db;

  static String createSql = '''
    create table multipartUploadTask ( 
      id integer primary key autoincrement, 
      fileName text not null,
      srcPath text not null,
      totalSize integer not null,
      uploadedSize integer not null,
      status integer not null,
      fileId integer not null,
      createTime text not null,
      md5 text not null,
      mediaType text,
      statusMessage text,
      parentId integer,
      targetType integer,
      spaceId integer,
      private bool,
      userId integer
    )
  ''';

  //何时调用：任务刚添加、任务上传完毕、任务出错、更新已上传分片数
  Future<MultipartUploadTask> insertOrUpdate(MultipartUploadTask task) async {
    task.id = await db.insert(
      "multipartUploadTask",
      task.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return task;
  }

  Future<void> delete(MultipartUploadTask task) async {
    if (task.id == null) {
      log('task.id为null');
      return;
    }
    task.id = await db.delete(
      "multipartUploadTask",
      where: "id=?",
      whereArgs: [task.id],
    );
  }

  Future<List<MultipartUploadTask>> getAllTaskList() async {
    var user = Global.user;
    if (user.id == null || user.id == 0) {
      return <MultipartUploadTask>[];
    }
    List<Map<String, Object?>> mapList = await db.query(
      "multipartUploadTask",
      where: "userId=?",
      whereArgs: [user.id],
      orderBy: "createTime",
    );
    List<MultipartUploadTask> list = [];
    for (var map in mapList) {
      list.add(MultipartUploadTask.fromJson(map));
    }
    return list;
  }
}
