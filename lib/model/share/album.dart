import 'package:json_annotation/json_annotation.dart';

part 'album.g.dart';

@JsonSerializable()
class Album {
  String? id;
  String? topicId;
  int? userId;
  String? title;
  String? introduction;
  String? coverUrl;
  int? albumType;
  DateTime? createTime;

  factory Album.fromJson(Map<String, dynamic> json) => _$AlbumFromJson(json);

  Map<String, dynamic> toJson() => _$AlbumToJson(this);

  Album();
}
