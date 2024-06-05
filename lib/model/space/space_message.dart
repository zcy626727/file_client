import 'package:json_annotation/json_annotation.dart';

part 'space_message.g.dart';

@JsonSerializable()
class SpaceMessage {
  int? id;
  String? message;
  int? type;

  factory SpaceMessage.fromJson(Map<String, dynamic> json) => _$SpaceMessageFromJson(json);

  Map<String, dynamic> toJson() => _$SpaceMessageToJson(this);

  SpaceMessage(this.id, this.message, this.type);
}
