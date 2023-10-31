// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trash.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Trash _$TrashFromJson(Map<String, dynamic> json) => Trash(
      id: json['id'],
      name: json['name'],
      userId: json['userId'] as int?,
      itemId: json['itemId'] as int?,
      type: json['type'] as int?,
    );

Map<String, dynamic> _$TrashToJson(Trash instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'userId': instance.userId,
      'itemId': instance.itemId,
      'type': instance.type,
      'status': instance.status,
    };
