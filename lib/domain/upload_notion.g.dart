// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upload_notion.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UploadNotion _$UploadNotionFromJson(Map<String, dynamic> json) => UploadNotion(
      UserFile.fromJson(json['userFile'] as Map<String, dynamic>),
      $enumDecode(_$UploadNotionTypeEnumMap, json['type']),
    );

Map<String, dynamic> _$UploadNotionToJson(UploadNotion instance) =>
    <String, dynamic>{
      'userFile': instance.userFile.toJson(),
      'type': _$UploadNotionTypeEnumMap[instance.type]!,
    };

const _$UploadNotionTypeEnumMap = {
  UploadNotionType.createUpload: 'createUpload',
  UploadNotionType.completeUpload: 'completeUpload',
};
