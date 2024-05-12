// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Application _$ApplicationFromJson(Map<String, dynamic> json) => Application()
  ..id = json['id'] as String?
  ..albumId = json['albumId'] as String?
  ..userId = (json['userId'] as num?)?.toInt()
  ..title = json['title'] as String?
  ..coverUrl = json['coverUrl'] as String?
  ..createTime = json['createTime'] == null ? null : DateTime.parse(json['createTime'] as String)
  ..order = (json['order'] as num?)?.toInt()
  ..fileId = (json['fileId'] as num?)?.toInt()
  ..introduction = json['introduction'] as String?
  ..version = (json['version'] as num?)?.toInt();

Map<String, dynamic> _$ApplicationToJson(Application instance) =>
    <String, dynamic>{
      'id': instance.id,
      'albumId': instance.albumId,
      'userId': instance.userId,
      'title': instance.title,
      'coverUrl': instance.coverUrl,
      'createTime': instance.createTime?.toIso8601String(),
      'order': instance.order,
      'fileId': instance.fileId,
      'introduction': instance.introduction,
      'version': instance.version,
    };
