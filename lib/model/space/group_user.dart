import 'package:json_annotation/json_annotation.dart';

part 'group_user.g.dart';

@JsonSerializable()
class GroupUser {
  int? id;
  int? userId;
  int? groupId;

  factory GroupUser.fromJson(Map<String, dynamic> json) => _$GroupUserFromJson(json);

  Map<String, dynamic> toJson() => _$GroupUserToJson(this);

  GroupUser(this.id, this.userId, this.groupId);
}
