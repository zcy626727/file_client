import 'package:json_annotation/json_annotation.dart';

part 'subscribe_topic.g.dart';

@JsonSerializable()
class SubscribeTopic {
  String? id;
  String? albumId;
  int? userId;

  factory SubscribeTopic.fromJson(Map<String, dynamic> json) => _$SubscribeTopicFromJson(json);

  Map<String, dynamic> toJson() => _$SubscribeTopicToJson(this);

  SubscribeTopic();
}