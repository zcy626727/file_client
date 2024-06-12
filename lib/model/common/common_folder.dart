import 'package:file_client/model/common/common_resource.dart';

import '../../constant/resource.dart';

class CommonFolder extends CommonResource {
  CommonFolder();

  CommonFolder.rootFolder() {
    id = 0;
    name = "根目录";
    status = FileStatus.normal;
    parentId = 0;
  }
}
