import 'package:json_annotation/json_annotation.dart';

part 'space.g.dart';

@JsonSerializable()
class Space {
  String? id;

  factory Space.fromJson(Map<String, dynamic> json) => _$SpaceFromJson(json);

  Map<String, dynamic> toJson() => _$SpaceToJson(this);

  Space();
}
