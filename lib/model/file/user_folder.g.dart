// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_folder.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserFolder _$UserFolderFromJson(Map<String, dynamic> json) => UserFolder(
      id: json['id'],
      name: json['name'],
      status: json['status'],
      parentId: json['parentId'] as int?,
      createTime: json['createTime'] == null
          ? null
          : DateTime.parse(json['createTime'] as String),
    );

Map<String, dynamic> _$UserFolderToJson(UserFolder instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'status': instance.status,
      'parentId': instance.parentId,
      'createTime': instance.createTime?.toIso8601String(),
    };
