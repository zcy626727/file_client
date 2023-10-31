import 'package:json_annotation/json_annotation.dart';

import '../../domain/resource.dart';

part 'user_file.g.dart';

@JsonSerializable()
class UserFile extends Resource {
  int? userId;
  int? parentId;
  int? fileId;
  int? fileSize; //字节为单位
  DateTime? createTime;
  String? coverUrl;
  String? mimeType;

  UserFile(
    id,
    name,
    status,
    this.userId,
    this.parentId,
    this.fileId,
    this.fileSize,
    this.createTime,
    this.coverUrl,
  ) : super(id, name, status);

  factory UserFile.fromJson(Map<String, dynamic> json) =>
      _$UserFileFromJson(json);

  Map<String, dynamic> toJson() => _$UserFileToJson(this);

  @override
  String toString() {
    return _$UserFileToJson(this).toString();
  }
}
