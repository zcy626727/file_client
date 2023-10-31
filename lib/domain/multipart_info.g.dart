// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'multipart_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MultipartInfo _$MultipartInfoFromJson(Map<String, dynamic> json) =>
    MultipartInfo(
      json['fileId'] as int?,
      json['finished'] as bool?,
      json['totalPartNum'] as int?,
      json['uploadedPartNum'] as int?,
      json['fileSize'] as int?,
      json['partSize'] as int?,
    );

Map<String, dynamic> _$MultipartInfoToJson(MultipartInfo instance) =>
    <String, dynamic>{
      'fileId': instance.fileId,
      'finished': instance.finished,
      'totalPartNum': instance.totalPartNum,
      'uploadedPartNum': instance.uploadedPartNum,
      'fileSize': instance.fileSize,
      'partSize': instance.partSize,
    };
