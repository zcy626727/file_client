import '../../api/client/file/share_api.dart';
import '../../config/net_config.dart';
import '../../model/file/share.dart';
import '../../model/file/user_file.dart';

class ShareService {
  static Future<Share> createShare({
    required List<int> userFileIdList,
    required DateTime endTime,
    String? code,
    required String name,
  }) async {
    var share = await ShareApi.createShare(
      userFileIdList: userFileIdList,
      endTime: endTime,
      code: code,
      name: name,
    );
    return share;
  }

  static Future<void> deleteShare({
    required int shareId,
  }) async {
    await ShareApi.deleteShare(shareId: shareId);
  }

  static Future<void> updateShareStatus({
    required int shareId,
    required int newStatus,
  }) async {
    await ShareApi.updateShareStatus(shareId: shareId, newStatus: newStatus);
  }

  static Future<List<Share>> getShareList({
    int pageIndex = 0,
    int pageSize = NetConfig.commonPageSize,
  }) async {
    var shareList = await ShareApi.getShareList(pageIndex: pageIndex, pageSize: pageSize);
    return shareList;
  }

  //获取自己分享的share信息
  static Future<Share> getShare({
    required int shareId,
  }) async {
    return await ShareApi.getShare(shareId: shareId);
  }

  static Future<List<UserFile>> accessShare({
    required String token,
    String? code,
    int? folderId,
    int pageIndex = 0,
    int pageSize = NetConfig.commonPageSize,
  }) async {
    return await ShareApi.accessShare(
      token: token,
      code: code,
      folderId: folderId,
      pageIndex: pageIndex,
      pageSize: pageSize,
    );
  }

  static Future<void> saveFileList({
    required String token,
    String? code,
    required List<int> userFileIdList,
    required int targetFolderId,
  }) async {
    await ShareApi.saveFileList(
      token: token,
      code: code,
      userFileIdList: userFileIdList,
      targetFolderId: targetFolderId,
    );
  }
}
