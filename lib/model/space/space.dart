import 'package:json_annotation/json_annotation.dart';

part 'space.g.dart';

@JsonSerializable()
class Space {
  int? id;
  int? creatorId;
  String? name;
  String? avatarUrl;

  factory Space.fromJson(Map<String, dynamic> json) => _$SpaceFromJson(json);

  Map<String, dynamic> toJson() => _$SpaceToJson(this);

  Space();
}
