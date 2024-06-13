// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'download_task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DownloadTask _$DownloadTaskFromJson(Map<String, dynamic> json) => DownloadTask()
  ..id = (json['id'] as num?)?.toInt()
  ..userId = (json['userId'] as num?)?.toInt()
  ..userFileId = (json['userFileId'] as num?)?.toInt()
  ..spaceId = (json['spaceId'] as num?)?.toInt()
  ..spaceFileId = (json['spaceFileId'] as num?)?.toInt()
  ..type = (json['type'] as num?)?.toInt()
  ..targetPath = json['targetPath'] as String?
  ..targetName = json['targetName'] as String?
  ..downloadUrl = json['downloadUrl'] as String?
  ..totalSize = (json['totalSize'] as num?)?.toInt()
  ..downloadedSize = (json['downloadedSize'] as num).toInt()
  ..statusMessage = json['statusMessage'] as String?
  ..status = (json['status'] as num?)?.toInt()
  ..createTime = json['createTime'] == null ? null : DateTime.parse(json['createTime'] as String);

Map<String, dynamic> _$DownloadTaskToJson(DownloadTask instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'userFileId': instance.userFileId,
      'spaceId': instance.spaceId,
      'spaceFileId': instance.spaceFileId,
      'type': instance.type,
      'targetPath': instance.targetPath,
      'targetName': instance.targetName,
      'downloadUrl': instance.downloadUrl,
      'totalSize': instance.totalSize,
      'downloadedSize': instance.downloadedSize,
      'statusMessage': instance.statusMessage,
      'status': instance.status,
      'createTime': instance.createTime?.toIso8601String(),
    };
