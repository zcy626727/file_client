
import 'package:file_client/model/share/source.dart';
import 'package:json_annotation/json_annotation.dart';

part 'application.g.dart';

@JsonSerializable()
class Application extends Source{
  int? fileId;
  String? introduction;
  int? version;

  factory Application.fromJson(Map<String, dynamic> json) => _$ApplicationFromJson(json);

  Map<String, dynamic> toJson() => _$ApplicationToJson(this);

  Application();
}
