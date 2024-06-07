// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'multipart_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MultipartInfo _$MultipartInfoFromJson(Map<String, dynamic> json) =>
    MultipartInfo(
      (json['fileId'] as num?)?.toInt(),
      json['finished'] as bool?,
      (json['totalPartNum'] as num?)?.toInt(),
      (json['uploadedPartNum'] as num?)?.toInt(),
      (json['fileSize'] as num?)?.toInt(),
      (json['partSize'] as num?)?.toInt(),
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
