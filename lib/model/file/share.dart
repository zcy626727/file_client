

import 'package:json_annotation/json_annotation.dart';

part 'share.g.dart';

@JsonSerializable()
class Share{
  int? id;
  int? userId;
  int? type;//
  int? status;//
  String? token;
  String? code;
  String? name;
  DateTime? createTime;
  DateTime? endTime;

  factory Share.fromJson(Map<String, dynamic> json) => _$ShareFromJson(json);

  Map<String, dynamic> toJson() => _$ShareToJson(this);

  Share();
}