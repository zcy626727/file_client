import 'package:json_annotation/json_annotation.dart';

import '../../config/constants.dart';
import '../common/common_file.dart';

part 'space_file.g.dart';

@JsonSerializable()
class SpaceFile extends CommonFile {
  int? spaceId;

  // 权限相关
  int? otherPermission;
  int? groupId;
  int? groupPermission;

  SpaceFile({
    this.spaceId,
    this.groupId,
    this.groupPermission,
    this.otherPermission,
  });

  SpaceFile.testFile() {
    spaceId = 1;
    groupId = 1;
    otherPermission = SpaceFilePermission.readonly;
    groupPermission = SpaceFilePermission.write;
    id = 1;
    name = "名字.txt";
    status = 1;
    parentId = 1;
    createTime = DateTime.now();
    coverUrl = errImageUrl;
    mimeType = "";
    fileId = 11;
    fileSize = 1000;
  }

  factory SpaceFile.fromJson(Map<String, dynamic> json) => _$SpaceFileFromJson(json);

  Map<String, dynamic> toJson() => _$SpaceFileToJson(this);

  @override
  String toString() {
    return _$SpaceFileToJson(this).toString();
  }
}

class SpaceFilePermission {
  // 可预览
  static const int readonly = 1;

  // 可编辑/删除/修改信息
  static const int write = 2;
}
