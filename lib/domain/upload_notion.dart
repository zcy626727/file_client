import 'package:file_client/model/common/common_resource.dart';

class UploadTaskNotion {
  CommonResource resource;
  int type;

  UploadTaskNotion({required this.resource, required this.type});
}

class UploadNotionType {
  static const int createUpload = 1;
  static const int completeUpload = 2;
}
