// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'download_task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DownloadTask _$DownloadTaskFromJson(Map<String, dynamic> json) => DownloadTask()
  ..id = json['id'] as int?
  ..userId = json['userId'] as int?
  ..userFileId = json['userFileId'] as int?
  ..targetPath = json['targetPath'] as String?
  ..targetName = json['targetName'] as String?
  ..downloadUrl = json['downloadUrl'] as String?
  ..totalSize = json['totalSize'] as int?
  ..downloadedSize = json['downloadedSize'] as int
  ..statusMessage = json['statusMessage'] as String?
  ..status = json['status'] as int?
  ..createTime = json['createTime'] == null
      ? null
      : DateTime.parse(json['createTime'] as String);

Map<String, dynamic> _$DownloadTaskToJson(DownloadTask instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'userFileId': instance.userFileId,
      'targetPath': instance.targetPath,
      'targetName': instance.targetName,
      'downloadUrl': instance.downloadUrl,
      'totalSize': instance.totalSize,
      'downloadedSize': instance.downloadedSize,
      'statusMessage': instance.statusMessage,
      'status': instance.status,
      'createTime': instance.createTime?.toIso8601String(),
    };
