import 'package:json_annotation/json_annotation.dart';

import '../model/file/user_file.dart';


part 'upload_notion.g.dart';

@JsonSerializable(explicitToJson: true)
class UploadNotion{
  UserFile userFile;
  UploadNotionType type;

  UploadNotion(this.userFile, this.type);

  factory UploadNotion.fromJson(Map<String, dynamic> json) => _$UploadNotionFromJson(json);

  Map<String, dynamic> toJson() => _$UploadNotionToJson(this);
}

enum UploadNotionType{
  createUpload,
  completeUpload,
}