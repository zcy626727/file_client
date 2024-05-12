
import '../../api/client/file/share_api.dart';
import '../../model/common/common_resource.dart';
import '../../model/file/share.dart';
import '../../model/file/user_file.dart';
import '../../model/file/user_folder.dart';
import '../../util/share.dart';

class ShareService {
  static Future<Share> createShare(
    List<UserFile> userFileList,
    List<UserFolder> userFolderList,
    DateTime endTime,
    String? code,
    String name,
  ) async {
    code ??= ShareUtil.generateCode();
    var share = await ShareApi.createShare(userFileList, userFolderList, endTime, code, name);
    return share;
  }

  static Future<List<Share>> getShareList() async {
    var shareList = await ShareApi.getShareList();
    return shareList;
  }

  static Future<String> deleteShare(int shareId) async {
    return await ShareApi.deleteShare(shareId);
  }

  static Future<String> updateShareStatus(int shareId, int newStatus) async {
    return await ShareApi.updateShareStatus(shareId, newStatus);
  }

  static Future<(String, List<CommonResource>)> getShareData(
    int shareId,
    String? code,
    int? folderId,
  ) async {
    var resourceList = await ShareApi.getShareData(shareId, code, folderId);
    return resourceList;
  }

  static Future<List<UserFolder>> getFolderPathInShare(
    int shareId,
    String? code,
    int folderId,
  ) async {
    return await ShareApi.getFolderPathInShare(shareId, code, folderId);
  }

  static Future<Share> getShareByToken(
    String token,
  ) async {
    return await ShareApi.getShareByToken(token);
  }

  static Future<String> saveResourceList(
    List<UserFile> userFileList,
    List<UserFolder> userFolderList,
    int shareId,
    String? code,
    int targetFolderId,
    bool isShareRoot,
  ) async {
    var share = await ShareApi.saveResourceList(userFileList, userFolderList, shareId, code, targetFolderId, isShareRoot);
    return share;
  }
}
