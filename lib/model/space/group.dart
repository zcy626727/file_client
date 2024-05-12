import 'package:json_annotation/json_annotation.dart';

part 'group.g.dart';

@JsonSerializable()
class Group {
  int? id;
  String? name;

  Group();

  Group.testGroup() {
    id = 1;
    name = "一个组";
  }
}
