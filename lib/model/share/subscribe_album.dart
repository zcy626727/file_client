import 'package:json_annotation/json_annotation.dart';

part 'subscribe_album.g.dart';

@JsonSerializable()
class SubscribeAlbum {
  String? id;
  String? albumId;
  int? userId;

  factory SubscribeAlbum.fromJson(Map<String, dynamic> json) => _$SubscribeAlbumFromJson(json);

  Map<String, dynamic> toJson() => _$SubscribeAlbumToJson(this);

  SubscribeAlbum();
}