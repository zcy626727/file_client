import 'package:file_client/model/share/source.dart';
import 'package:json_annotation/json_annotation.dart';

part 'audio.g.dart';

@JsonSerializable()
class Audio  extends Source{
  int? fileId;

  factory Audio.fromJson(Map<String, dynamic> json) => _$AudioFromJson(json);

  Map<String, dynamic> toJson() => _$AudioToJson(this);

  Audio();
}