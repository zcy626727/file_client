import 'package:json_annotation/json_annotation.dart';

import '../user/user.dart';

part 'space_user.g.dart';

@JsonSerializable()
class SpaceUser {
  int? id;
  int? userId;
  int? spaceId;
  int? userPermission;

  @JsonKey(includeFromJson: false, includeToJson: false)
  User? user;

  SpaceUser(this.id, this.userId, this.spaceId, this.userPermission);

  factory SpaceUser.fromJson(Map<String, dynamic> json) => _$SpaceUserFromJson(json);

  Map<String, dynamic> toJson() => _$SpaceUserToJson(this);
}
