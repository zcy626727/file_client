// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gallery.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Gallery _$GalleryFromJson(Map<String, dynamic> json) => Gallery()
  ..id = json['id'] as String?
  ..albumId = json['albumId'] as String?
  ..userId = json['userId'] as int?
  ..title = json['title'] as String?
  ..coverUrl = json['coverUrl'] as String?
  ..createTime = json['createTime'] == null
      ? null
      : DateTime.parse(json['createTime'] as String)
  ..order = json['order'] as int?
  ..fileIdList =
      (json['fileIdList'] as List<dynamic>?)?.map((e) => e as int).toList()
  ..thumbnailUrlList = (json['thumbnailUrlList'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList();

Map<String, dynamic> _$GalleryToJson(Gallery instance) => <String, dynamic>{
      'id': instance.id,
      'albumId': instance.albumId,
      'userId': instance.userId,
      'title': instance.title,
      'coverUrl': instance.coverUrl,
      'createTime': instance.createTime?.toIso8601String(),
      'order': instance.order,
      'fileIdList': instance.fileIdList,
      'thumbnailUrlList': instance.thumbnailUrlList,
    };
