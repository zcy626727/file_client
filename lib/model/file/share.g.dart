// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'share.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Share _$ShareFromJson(Map<String, dynamic> json) => Share()
  ..id = (json['id'] as num?)?.toInt()
  ..userId = (json['userId'] as num?)?.toInt()
  ..type = (json['type'] as num?)?.toInt()
  ..status = (json['status'] as num?)?.toInt()
  ..token = json['token'] as String?
  ..code = json['code'] as String?
  ..name = json['name'] as String?
  ..createTime = json['createTime'] == null ? null : DateTime.parse(json['createTime'] as String)
  ..endTime = json['endTime'] == null ? null : DateTime.parse(json['endTime'] as String);

Map<String, dynamic> _$ShareToJson(Share instance) => <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'type': instance.type,
      'status': instance.status,
      'token': instance.token,
      'code': instance.code,
      'name': instance.name,
      'createTime': instance.createTime?.toIso8601String(),
      'endTime': instance.endTime?.toIso8601String(),
    };
