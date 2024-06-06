import 'package:file_client/config/constants.dart';
import 'package:file_client/model/common/common_file.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../constant/resource.dart';

part 'user_file.g.dart';

@JsonSerializable()
class UserFile extends CommonFile {
  UserFile();

  UserFile.testUser() {
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

  factory UserFile.fromJson(Map<String, dynamic> json) => _$UserFileFromJson(json);

  Map<String, dynamic> toJson() => _$UserFileToJson(this);

  @override
  String toString() {
    return _$UserFileToJson(this).toString();
  }

  UserFile.rootFolder() {
    id = 0;
    name = "根目录";
    status = FileStatus.normal.index;
    parentId = 0;
    createTime = null;
  }
}
