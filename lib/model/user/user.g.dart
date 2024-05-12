// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: (json['id'] as num?)?.toInt(),
      phoneNumber: json['phoneNumber'] as String?,
      lastLoginTime: json['lastLoginTime'] as String?,
      token: json['token'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      name: json['name'] as String?,
      themeMode: (json['themeMode'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'phoneNumber': instance.phoneNumber,
      'id': instance.id,
      'name': instance.name,
      'token': instance.token,
      'lastLoginTime': instance.lastLoginTime,
      'avatarUrl': instance.avatarUrl,
      'themeMode': instance.themeMode,
    };
