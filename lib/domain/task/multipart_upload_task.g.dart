// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'multipart_upload_task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MultipartUploadTask _$MultipartUploadTaskFromJson(Map<String, dynamic> json) =>
    MultipartUploadTask()
      ..id = json['id'] as int?
      ..fileName = json['fileName'] as String?
      ..srcPath = json['srcPath'] as String?
      ..totalSize = json['totalSize'] as int?
      ..uploadedSize = json['uploadedSize'] as int
      ..md5 = json['md5'] as String?
      ..status = json['status'] as int?
      ..statusMessage = json['statusMessage'] as String?
      ..createTime = json['createTime'] == null
          ? null
          : DateTime.parse(json['createTime'] as String)
      ..fileId = json['fileId'] as int?
      ..private = json['private'] as bool?
      ..mediaType = json['mediaType'] as int?
      ..parentId = json['parentId'] as int?
      ..userId = json['userId'] as int?;

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
    };
