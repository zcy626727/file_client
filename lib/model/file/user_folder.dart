import 'package:json_annotation/json_annotation.dart';

import '../../domain/resource.dart';
import '../../constant/resource.dart';

part 'user_folder.g.dart';

@JsonSerializable()
class UserFolder extends Resource {
  int? parentId;
  DateTime? createTime;

  UserFolder({id, name, status, this.parentId, this.createTime}) : super(id, name, status);

  factory UserFolder.fromJson(Map<String, dynamic> json) => _$UserFolderFromJson(json);

  Map<String, dynamic> toJson() => _$UserFolderToJson(this);

  UserFolder.rootFolder()
      : super(
          0,
          "根目录",
          ResourceStatus.normal.index,
        ) {
    parentId = 0;
    createTime = null;
  }
}
