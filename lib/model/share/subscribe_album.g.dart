// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscribe_album.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubscribeAlbum _$SubscribeAlbumFromJson(Map<String, dynamic> json) =>
    SubscribeAlbum()
      ..id = json['id'] as String?
      ..albumId = json['albumId'] as String?
      ..userId = json['userId'] as int?;

Map<String, dynamic> _$SubscribeAlbumToJson(SubscribeAlbum instance) =>
    <String, dynamic>{
      'id': instance.id,
      'albumId': instance.albumId,
      'userId': instance.userId,
    };
