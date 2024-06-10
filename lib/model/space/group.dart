import 'package:json_annotation/json_annotation.dart';

part 'group.g.dart';

@JsonSerializable()
class Group {
  int? id;
  int? spaceId;
  String? name;

  Group();

  Group.testGroup() {
    id = 1;
    name = "一个组";
  }

  void copyGroup(Group g) {
    id = g.id;
    spaceId = g.spaceId;
    name = g.name;
  }

  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);

  Map<String, dynamic> toJson() => _$GroupToJson(this);
}
