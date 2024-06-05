// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'single_upload_task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SingleUploadTask _$SingleUploadTaskFromJson(Map<String, dynamic> json) => SingleUploadTask()
  ..id = (json['id'] as num?)?.toInt()
  ..srcPath = json['srcPath'] as String?
  ..totalSize = (json['totalSize'] as num?)?.toInt()
  ..uploadedSize = (json['uploadedSize'] as num).toInt()
  ..md5 = json['md5'] as String?
  ..fileId = (json['fileId'] as num?)?.toInt()
  ..statusMessage = json['statusMessage'] as String?
  ..status = (json['status'] as num?)?.toInt()
  ..createTime = json['createTime'] == null ? null : DateTime.parse(json['createTime'] as String)
  ..private = json['private'] as bool?
  ..mediaType = (json['mediaType'] as num?)?.toInt()
  ..coverUrl = json['coverUrl'] as String?
  ..magicNumber = (json['magicNumber'] as List<dynamic>?)?.map((e) => (e as num).toInt()).toList();

Map<String, dynamic> _$SingleUploadTaskToJson(SingleUploadTask instance) =>
    <String, dynamic>{
      'id': instance.id,
      'srcPath': instance.srcPath,
      'totalSize': instance.totalSize,
      'uploadedSize': instance.uploadedSize,
      'md5': instance.md5,
      'fileId': instance.fileId,
      'statusMessage': instance.statusMessage,
      'status': instance.status,
      'createTime': instance.createTime?.toIso8601String(),
      'private': instance.private,
      'mediaType': instance.mediaType,
      'coverUrl': instance.coverUrl,
      'magicNumber': instance.magicNumber,
    };
