// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'multipart_upload_task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MultipartUploadTask _$MultipartUploadTaskFromJson(Map<String, dynamic> json) => MultipartUploadTask()
  ..id = (json['id'] as num?)?.toInt()
  ..fileName = json['fileName'] as String?
  ..srcPath = json['srcPath'] as String?
  ..totalSize = (json['totalSize'] as num?)?.toInt()
  ..uploadedSize = (json['uploadedSize'] as num).toInt()
  ..md5 = json['md5'] as String?
  ..status = (json['status'] as num?)?.toInt()
  ..statusMessage = json['statusMessage'] as String?
  ..createTime = json['createTime'] == null ? null : DateTime.parse(json['createTime'] as String)
  ..fileId = (json['fileId'] as num?)?.toInt()
  ..private = json['private'] as bool?
  ..mediaType = (json['mediaType'] as num?)?.toInt()
  ..parentId = (json['parentId'] as num?)?.toInt()
  ..userId = (json['userId'] as num?)?.toInt()
  ..targetType = (json['targetType'] as num?)?.toInt()
  ..spaceId = (json['spaceId'] as num?)?.toInt();

Map<String, dynamic> _$MultipartUploadTaskToJson(
        MultipartUploadTask instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fileName': instance.fileName,
      'srcPath': instance.srcPath,
      'totalSize': instance.totalSize,
      'uploadedSize': instance.uploadedSize,
      'md5': instance.md5,
      'status': instance.status,
      'statusMessage': instance.statusMessage,
      'createTime': instance.createTime?.toIso8601String(),
      'fileId': instance.fileId,
      'private': instance.private,
      'mediaType': instance.mediaType,
      'parentId': instance.parentId,
      'userId': instance.userId,
      'targetType': instance.targetType,
      'spaceId': instance.spaceId,
    };
