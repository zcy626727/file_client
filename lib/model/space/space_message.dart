import 'package:json_annotation/json_annotation.dart';

import '../user/user.dart';

part 'space_message.g.dart';

@JsonSerializable()
class SpaceMessage {
  int? id;
  int? userId;
  int? spaceId;
  String? message;
  int? type;

  @JsonKey(includeFromJson: false, includeToJson: false)
  User? user;

  factory SpaceMessage.fromJson(Map<String, dynamic> json) => _$SpaceMessageFromJson(json);

  Map<String, dynamic> toJson() => _$SpaceMessageToJson(this);

  SpaceMessage(this.id, this.message, this.type);
}
