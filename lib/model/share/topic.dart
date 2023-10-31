import 'package:json_annotation/json_annotation.dart';

part 'topic.g.dart';

@JsonSerializable()
class Topic{
  String? id;
  int? userId;
  String? title;
  String? introduction;
  String? coverUrl;
  DateTime? createTime;

  factory Topic.fromJson(Map<String, dynamic> json) => _$TopicFromJson(json);

  Map<String, dynamic> toJson() => _$TopicToJson(this);

  Topic();
}