// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'album.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Album _$AlbumFromJson(Map<String, dynamic> json) => Album()
  ..id = json['id'] as String?
  ..topicId = json['topicId'] as String?
  ..userId = json['userId'] as int?
  ..title = json['title'] as String?
  ..introduction = json['introduction'] as String?
  ..coverUrl = json['coverUrl'] as String?
  ..albumType = json['albumType'] as int?
  ..createTime = json['createTime'] == null
      ? null
      : DateTime.parse(json['createTime'] as String);

Map<String, dynamic> _$AlbumToJson(Album instance) => <String, dynamic>{
      'id': instance.id,
      'topicId': instance.topicId,
      'userId': instance.userId,
      'title': instance.title,
      'introduction': instance.introduction,
      'coverUrl': instance.coverUrl,
      'albumType': instance.albumType,
      'createTime': instance.createTime?.toIso8601String(),
    };
