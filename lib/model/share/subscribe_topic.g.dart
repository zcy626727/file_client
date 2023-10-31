// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscribe_topic.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubscribeTopic _$SubscribeTopicFromJson(Map<String, dynamic> json) =>
    SubscribeTopic()
      ..id = json['id'] as String?
      ..albumId = json['albumId'] as String?
      ..userId = json['userId'] as int?;

Map<String, dynamic> _$SubscribeTopicToJson(SubscribeTopic instance) =>
    <String, dynamic>{
      'id': instance.id,
      'albumId': instance.albumId,
      'userId': instance.userId,
    };
