import 'package:json_annotation/json_annotation.dart';

import '../../constant/resource.dart';
import '../common/common_folder.dart';

part 'user_folder.g.dart';

@JsonSerializable()
class UserFolder extends CommonFolder {
  int? userId;

  UserFolder({
    this.userId,
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

  factory UserFolder.fromJson(Map<String, dynamic> json) => _$UserFolderFromJson(json);

  Map<String, dynamic> toJson() => _$UserFolderToJson(this);

  UserFolder.testFolder() {
    userId = 1;
    id = 1;
    name = "名字";
    status = 1;
    parentId = 1;
    createTime = DateTime.now();
  }

  UserFolder.rootFolder()
      : super(
          id: 0,
          name: "根目录",
          status: ResourceStatus.normal.index,
          parentId: 0,
          createTime: null,
        );
}
