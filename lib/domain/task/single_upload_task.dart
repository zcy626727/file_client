
import 'package:json_annotation/json_annotation.dart';

part 'single_upload_task.g.dart';

/// 上传任务（文件/文件夹）
/// 文件：
/// 文件夹：
@JsonSerializable()
class SingleUploadTask {
  int? id;
  String? srcPath; //文件原路径
  int? totalSize; //文件/文件夹下的文件的大小
  int uploadedSize = 0; //进度
  String? md5; //文件的MD5
  int? fileId;
  String? statusMessage; //文件的MD5
  int? status; //上传状态
  DateTime? createTime;
  bool? private;


  //额外业务信息
  int? mediaType;
  String? coverUrl;
  List<int>? magicNumber;

  SingleUploadTask();

  SingleUploadTask.all({
    required this.srcPath,
    this.uploadedSize = 0,
    required this.totalSize,
    this.statusMessage,
    required this.status,
    required this.mediaType,
    this.createTime,
    this.md5,
    this.private,
    required this.magicNumber,
  });


  void copy(SingleUploadTask task) {
    id = task.id;
    srcPath = task.srcPath;
    uploadedSize = task.uploadedSize;
    totalSize = task.totalSize;
    status = task.status;
    mediaType = task.mediaType;
    createTime = task.createTime;
    statusMessage = task.statusMessage;
    md5 = task.md5;
    magicNumber = task.magicNumber;
    fileId = task.fileId;
    private = task.private;
    coverUrl = task.coverUrl;
  }

  void clear() {
    id = null;
    srcPath = null;
    uploadedSize = 0;
    totalSize = null;
    status = null;
    mediaType = null;
    createTime = null;
    statusMessage = null;
    md5 = null;
    magicNumber = null;
    fileId = null;
    private = null;
    coverUrl = null;
  }

  factory SingleUploadTask.fromJson(Map<String, dynamic> json) => _$SingleUploadTaskFromJson(json);

  Map<String, dynamic> toJson() => _$SingleUploadTaskToJson(this);
}




