import '../../api/client/file/resource_api.dart';
import '../../constant/file.dart';
import '../../domain/resource.dart';

class ResourceService {
  static Future<List<Resource>> getFileAndFolderList({
    required int parentId,
    required List<int> statusList,
    int fileType = FileType.any,
  }) async {
    return await ResourceApi.getFileAndFolderList(parentId: parentId, statusList: statusList, fileType: fileType);
  }
}
