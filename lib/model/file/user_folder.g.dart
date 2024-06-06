// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_folder.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserFolder _$UserFolderFromJson(Map<String, dynamic> json) => UserFolder()
  ..id = (json['id'] as num?)?.toInt()
  ..name = json['name'] as String?
  ..status = (json['status'] as num?)?.toInt()
  ..userId = (json['userId'] as num?)?.toInt()
  ..parentId = (json['parentId'] as num?)?.toInt()
  ..fileType = (json['fileType'] as num?)?.toInt()
  ..createTime = json['createTime'] == null ? null : DateTime.parse(json['createTime'] as String);

Map<String, dynamic> _$UserFolderToJson(UserFolder instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'status': instance.status,
      'userId': instance.userId,
      'parentId': instance.parentId,
      'fileType': instance.fileType,
      'createTime': instance.createTime?.toIso8601String(),
    };
