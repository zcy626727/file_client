// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trash.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Trash _$TrashFromJson(Map<String, dynamic> json) => Trash(
      id: json['id'],
      name: json['name'],
      userId: (json['userId'] as num?)?.toInt(),
      itemId: (json['itemId'] as num?)?.toInt(),
      type: (json['type'] as num?)?.toInt(),
    )
      ..status = (json['status'] as num?)?.toInt()
      ..parentId = (json['parentId'] as num?)?.toInt()
      ..createTime = json['createTime'] == null ? null : DateTime.parse(json['createTime'] as String);

Map<String, dynamic> _$TrashToJson(Trash instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'status': instance.status,
      'parentId': instance.parentId,
      'createTime': instance.createTime?.toIso8601String(),
      'userId': instance.userId,
      'itemId': instance.itemId,
      'type': instance.type,
    };
