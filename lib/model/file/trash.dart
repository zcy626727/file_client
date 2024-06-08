import 'package:json_annotation/json_annotation.dart';

import '../common/common_resource.dart';

part 'trash.g.dart';

@JsonSerializable()
class Trash {
  int? id;
  int? userFileId;
  int? userId;
  String? name;

  @JsonKey(includeFromJson: false, includeToJson: false)
  CommonResource? file;

  Trash({
    this.id,
    this.userFileId,
    this.userId,
    this.name,
  });

  factory Trash.fromJson(Map<String, dynamic> json) => _$TrashFromJson(json);

  Map<String, dynamic> toJson() => _$TrashToJson(this);
}
