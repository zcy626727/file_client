import '../../api/client/file/trash_api.dart';
import '../../config/net_config.dart';
import '../../model/file/trash.dart';

class TrashService {
  static Future<List<Trash>> getTrashList({
    int pageIndex = 0,
    int pageSize = NetConfig.commonPageSize,
  }) async {
    return TrashApi.getTrashList(pageIndex: pageIndex, pageSize: pageSize);
  }

  static Future<void> recoverTrash({
    required int trashId,
  }) async {
    await TrashApi.recoverTrash(trashId: trashId);
  }

  static Future<void> recoverTrashList({
    required List<int> trashIdList,
  }) async {
    await TrashApi.recoverTrashList(trashIdList: trashIdList);
  }

  static Future<void> deleteTrash({
    required int trashId,
  }) async {
    TrashApi.deleteTrash(trashId: trashId);
  }

  static Future<void> deleteTrashList({
    required List<int> trashIdList,
  }) async {
    TrashApi.deleteTrashList(trashIdList: trashIdList);
  }
}
