import 'package:file_client/config/constants.dart';
import 'package:json_annotation/json_annotation.dart';

import '../common/common_file.dart';

part 'user_file.g.dart';

@JsonSerializable()
class UserFile extends CommonFile {
  int? userId;

  UserFile({
    this.userId,
    id,
    name,
    status,
    parentId,
    createTime,
    coverUrl,
    mimeType,
    fileId,
    fileSize,
  }) : super(
          id: id,
          name: name,
          status: status,
          parentId: parentId,
          createTime: createTime,
          coverUrl: coverUrl,
          mimeType: mimeType,
          fileId: fileId,
          fileSize: fileSize,
        );

  factory UserFile.fromJson(Map<String, dynamic> json) => _$UserFileFromJson(json);

  Map<String, dynamic> toJson() => _$UserFileToJson(this);

  UserFile.testUser() {
    userId = 1;
    id = 1;
    name = "名字";
    status = 1;
    parentId = 1;
    createTime = DateTime.now();
    coverUrl = errImageUrl;
    mimeType = "";
    fileId = 11;
    fileSize = 1000;
  }

  @override
  String toString() {
    return _$UserFileToJson(this).toString();
  }
}
