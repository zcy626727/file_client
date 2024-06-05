import 'package:json_annotation/json_annotation.dart';

part 'space_user.g.dart';

@JsonSerializable()
class SpaceUser {
  int? id;
  int? userId;
  int? spaceId;
  int? userPermission;

  SpaceUser(this.id, this.userId, this.spaceId, this.userPermission);

  factory SpaceUser.fromJson(Map<String, dynamic> json) => _$SpaceUserFromJson(json);

  Map<String, dynamic> toJson() => _$SpaceUserToJson(this);
}
