// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_file.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserFile _$UserFileFromJson(Map<String, dynamic> json) => UserFile(
      userId: (json['userId'] as num?)?.toInt(),
      id: json['id'],
      name: json['name'],
      status: json['status'],
      parentId: json['parentId'],
      createTime: json['createTime'],
      coverUrl: json['coverUrl'],
      mimeType: json['mimeType'],
      fileId: json['fileId'],
      fileSize: json['fileSize'],
    );

Map<String, dynamic> _$UserFileToJson(UserFile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'status': instance.status,
      'parentId': instance.parentId,
      'createTime': instance.createTime?.toIso8601String(),
      'coverUrl': instance.coverUrl,
      'mimeType': instance.mimeType,
      'fileId': instance.fileId,
      'fileSize': instance.fileSize,
      'userId': instance.userId,
    };
