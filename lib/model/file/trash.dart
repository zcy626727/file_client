import 'package:json_annotation/json_annotation.dart';

import '../../constant/resource.dart';
import '../common/common_resource.dart';

part 'trash.g.dart';

@JsonSerializable()
class Trash extends CommonResource {
  int? userId;
  int? itemId;
  int? type;

  // @override
  // @JsonKey(includeFromJson: false, includeToJson: true)
  // int? status = ResourceStatus.deleted.index;

  Trash({
    id,
    name,
    this.userId,
    this.itemId,
    this.type,
  }) : super(
          id: id,
          name: name,
          status: ResourceStatus.deleted.index,
        );

  factory Trash.fromJson(Map<String, dynamic> json) => _$TrashFromJson(json);

  Map<String, dynamic> toJson() => _$TrashToJson(this);
}
