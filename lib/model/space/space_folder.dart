import 'package:file_client/model/file/user_folder.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../constant/resource.dart';

part 'space_folder.g.dart';

@JsonSerializable()
class SpaceFolder extends UserFolder {
  int? spaceId;

  // 权限相关
  int? otherPermission;
  int? groupId;
  int? groupPermission;

  SpaceFolder({
    this.spaceId,
    this.otherPermission,
    this.groupId,
    this.groupPermission,
    id,
    name,
    status,
    parentId,
    createTime,
  }) : super(
          id: id,
          name: name,
          status: status,
          parentId: parentId,
          createTime: createTime,
        );

  factory SpaceFolder.fromJson(Map<String, dynamic> json) => _$SpaceFolderFromJson(json);

  Map<String, dynamic> toJson() => _$SpaceFolderToJson(this);

  SpaceFolder.testFolder() {
    spaceId = 1;
    groupId = 1;
    otherPermission = SpaceFolderPermission.readonly;
    groupPermission = SpaceFolderPermission.write;
    id = 1;
    name = "名字";
    status = 1;
    parentId = 1;
    createTime = DateTime.now();
  }

  SpaceFolder.rootFolder()
      : super(
          id: 0,
          name: "根目录",
          status: ResourceStatus.normal.index,
          parentId: 0,
          createTime: null,
        );
}

class SpaceFolderPermission {
  // 可预览
  static const int readonly = 1;

  // 可编辑/删除/修改信息/文件夹内创建资源
  static const int write = 2;
}
