// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_folder.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserFolder _$UserFolderFromJson(Map<String, dynamic> json) => UserFolder(
  userId: (json['userId'] as num?)?.toInt(),
      id: json['id'],
      name: json['name'],
      status: json['status'],
      parentId: json['parentId'],
      createTime: json['createTime'],
    );

Map<String, dynamic> _$UserFolderToJson(UserFolder instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'status': instance.status,
      'parentId': instance.parentId,
      'createTime': instance.createTime?.toIso8601String(),
      'userId': instance.userId,
    };
