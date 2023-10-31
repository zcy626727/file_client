import 'package:json_annotation/json_annotation.dart';

import '../../domain/resource.dart';
import '../../constant/resource.dart';


part 'trash.g.dart';

@JsonSerializable()
class Trash extends Resource {
  int? userId;
  int? itemId;
  int? type;

  @override
  @JsonKey(includeFromJson: false, includeToJson: true)
  int? status = ResourceStatus.deleted.index;

  Trash({id, name, this.userId, this.itemId, this.type})
      : super(id, name, ResourceStatus.deleted.index);

  factory Trash.fromJson(Map<String, dynamic> json) => _$TrashFromJson(json);

  Map<String, dynamic> toJson() => _$TrashToJson(this);
}
