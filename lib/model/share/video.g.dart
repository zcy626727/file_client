// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Video _$VideoFromJson(Map<String, dynamic> json) => Video()
  ..id = json['id'] as String?
  ..albumId = json['albumId'] as String?
  ..userId = json['userId'] as int?
  ..title = json['title'] as String?
  ..coverUrl = json['coverUrl'] as String?
  ..createTime = json['createTime'] == null
      ? null
      : DateTime.parse(json['createTime'] as String)
  ..order = json['order'] as int?
  ..fileId = json['fileId'] as int?;

Map<String, dynamic> _$VideoToJson(Video instance) => <String, dynamic>{
      'id': instance.id,
      'albumId': instance.albumId,
      'userId': instance.userId,
      'title': instance.title,
      'coverUrl': instance.coverUrl,
      'createTime': instance.createTime?.toIso8601String(),
      'order': instance.order,
      'fileId': instance.fileId,
    };
