import 'package:file_client/model/share/source.dart';
import 'package:json_annotation/json_annotation.dart';

part 'gallery.g.dart';

@JsonSerializable()
class Gallery extends Source{
  List<int>? fileIdList;
  List<String>? thumbnailUrlList;

  factory Gallery.fromJson(Map<String, dynamic> json) => _$GalleryFromJson(json);

  Map<String, dynamic> toJson() => _$GalleryToJson(this);

  Gallery();
}
