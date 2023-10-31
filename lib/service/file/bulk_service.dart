import 'package:file_client/api/client/file/bulk_api.dart';

class BulkService {
  static Future<void> moveResourceList({
    required int oldParentId,
    required int newParentId,
    required List<int> userFileIdList,
    required List<int> userFolderIdList,
  }) async {
    await BulkApi.moveResourceList(oldParentId, newParentId, userFileIdList, userFolderIdList);
  }

  static Future<void> deleteResourceList({
    required List<int> userFileIdList,
    required List<int> userFolderIdList,
  }) async {
    await BulkApi.deleteResourceList(userFileIdList, userFolderIdList);
  }

  static Future<void> recoverTrashItemList({
    required List<int> trashIdList,
  }) async {
    if (trashIdList.isEmpty) return;
    await BulkApi.recoverTrashItemList(trashIdList);
  }

  static Future<void> deleteTrashItemList({
    required List<int> trashIdList,
  }) async {
    await BulkApi.deleteTrashItemList(trashIdList);
  }
}
