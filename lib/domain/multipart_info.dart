import 'package:json_annotation/json_annotation.dart';

part 'multipart_info.g.dart';

@JsonSerializable()
class MultipartInfo {
  int? fileId;
  bool? finished;
  int? totalPartNum;
  int? uploadedPartNum;
  int? fileSize;
  int? partSize;

  MultipartInfo(
    this.fileId,
    this.finished,
    this.totalPartNum,
    this.uploadedPartNum,
    this.fileSize,
    this.partSize,
  );

  factory MultipartInfo.fromJson(Map<String, dynamic> json) =>
      _$MultipartInfoFromJson(json);

  Map<String, dynamic> toJson() => _$MultipartInfoToJson(this);
}
