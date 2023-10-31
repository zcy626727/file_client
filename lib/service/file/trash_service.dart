
import '../../api/client/file/trash_api.dart';
import '../../model/file/trash.dart';

class TrashService{
  static Future<List<Trash>> getTrashList() async {
    return TrashApi.getTrashList();
  }

  static Future<String> recoverItem(int trashId) async {
    return TrashApi.recoverItem(trashId);
  }


  static Future<String> deleteItem(int trashId) async {
    return TrashApi.deleteItem(trashId);
  }

}