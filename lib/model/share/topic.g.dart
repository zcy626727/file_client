// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'topic.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Topic _$TopicFromJson(Map<String, dynamic> json) => Topic()
  ..id = json['id'] as String?
  ..userId = (json['userId'] as num?)?.toInt()
  ..title = json['title'] as String?
  ..introduction = json['introduction'] as String?
  ..coverUrl = json['coverUrl'] as String?
  ..createTime = json['createTime'] == null
      ? null
      : DateTime.parse(json['createTime'] as String);

Map<String, dynamic> _$TopicToJson(Topic instance) => <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'title': instance.title,
      'introduction': instance.introduction,
      'coverUrl': instance.coverUrl,
      'createTime': instance.createTime?.toIso8601String(),
    };
