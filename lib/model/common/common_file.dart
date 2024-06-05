import 'common_resource.dart';

class CommonFile extends CommonResource {
  // 预览图
  String? coverUrl;

  // 文件魔符
  String? mimeType;

  // 文件在文件系统上的唯一id
  int? fileId;

  // 文件大小，以字节为单位
  int? fileSize;

  CommonFile({
    this.coverUrl,
    this.mimeType,
    this.fileId,
    this.fileSize,
  });
}
