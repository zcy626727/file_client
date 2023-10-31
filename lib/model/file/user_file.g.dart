// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_file.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserFile _$UserFileFromJson(Map<String, dynamic> json) => UserFile(
      json['id'],
      json['name'],
      json['status'],
      json['userId'] as int?,
      json['parentId'] as int?,
      json['fileId'] as int?,
      json['fileSize'] as int?,
      json['createTime'] == null
          ? null
          : DateTime.parse(json['createTime'] as String),
      json['coverUrl'] as String?,
    )..mimeType = json['mimeType'] as String?;

Map<String, dynamic> _$UserFileToJson(UserFile instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'status': instance.status,
      'userId': instance.userId,
      'parentId': instance.parentId,
      'fileId': instance.fileId,
      'fileSize': instance.fileSize,
      'createTime': instance.createTime?.toIso8601String(),
      'coverUrl': instance.coverUrl,
      'mimeType': instance.mimeType,
    };
