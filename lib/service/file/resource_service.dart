import '../../api/client/file/resource_api.dart';
import '../../constant/file.dart';
import '../../model/common/common_resource.dart';

class ResourceService {
  static Future<List<CommonResource>> getFileAndFolderList({
    required int parentId,
    required List<int> statusList,
    int fileType = FileType.any,
  }) async {
    return await ResourceApi.getFileAndFolderList(parentId: parentId, statusList: statusList, fileType: fileType);
  }
}
