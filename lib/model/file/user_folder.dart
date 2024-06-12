import 'package:json_annotation/json_annotation.dart';

import '../../constant/resource.dart';
import '../common/common_folder.dart';

part 'user_folder.g.dart';

@JsonSerializable()
class UserFolder extends CommonFolder {

  UserFolder() : super();

  UserFolder.testFolder() {
    id = 1;
    name = "名字";
    status = 1;
    parentId = 1;
    createTime = DateTime.now();
  }

  UserFolder.rootFolder() {
    id = 0;
    name = "根目录";
    status = FileStatus.normal;
    parentId = 0;
    createTime = null;
  }

  factory UserFolder.fromJson(Map<String, dynamic> json) => _$UserFolderFromJson(json);

  Map<String, dynamic> toJson() => _$UserFolderToJson(this);
}
