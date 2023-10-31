
import '../../api/client/file/user_folder_api.dart';
import '../../model/file/user_folder.dart';

class UserFolderService {
  static Future<UserFolder> createFolder(
      int parentId, String folderName) async {
    var userFolder = await UserFolderApi.createFolder(parentId, folderName);
    return userFolder;
  }

  static Future<void> deleteFolder(int folderId) async {
    await UserFolderApi.deleteFolder(folderId);
  }

  static Future<void> renameFolder({
    required int folderId,
    required String newFolderName,
    required String oldFolderName,
  }) async {
    await UserFolderApi.renameFolder(folderId, newFolderName, oldFolderName);
  }


  static Future<void> moveFolder({
    required int folderId,
    required int oldParentId,
    required int newParentId,
  }) async {
    await UserFolderApi.moveFolder(folderId, oldParentId, newParentId);
  }

  static Future<List<UserFolder>> getFolderList(
    int parentId,
    List<int> statusList,
  ) async {
    return await UserFolderApi.getFolderList(parentId, statusList);
  }
}
