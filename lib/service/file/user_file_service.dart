import 'package:file_client/config/net_config.dart';

import '../../api/client/file/user_file_api.dart';
import '../../model/common/common_resource.dart';
import '../../model/file/user_file.dart';

class UserFileService {
  static Future<UserFile> createFile({
    required String filename,
    required int fileId,
    required int parentId,
  }) async {
    var userFile = await UserFileApi.createFile(filename: filename, fileId: fileId, parentId: parentId);
    return userFile;
  }

  static Future<UserFile> createFolder({
    required String folderName,
    required int parentId,
  }) async {
    var userFile = await UserFileApi.createFolder(folderName: folderName, parentId: parentId);
    return userFile;
  }

  static Future<void> deleteFile({
    required int userFileId,
  }) async {
    await UserFileApi.deleteFile(userFileId: userFileId);
  }

  static Future<void> deleteFileList({
    required List<int> userFileIdList,
  }) async {
    await UserFileApi.deleteFileList(userFileIdList: userFileIdList);
  }

  static Future<void> renameFile({
    required int userFileId,
    required String newFilename,
  }) async {
    await UserFileApi.renameFile(userFileId: userFileId, newFilename: newFilename);
  }

  static Future<void> moveFile({
    required int fileId,
    required int newParentId,
    required bool keepUnique,
  }) async {
    await UserFileApi.moveFile(fileId: fileId, newParentId: newParentId, keepUnique: keepUnique);
  }

  static Future<void> moveFileList({
    required List<int> userFileIdList,
    required int newParentId,
    required bool keepUnique,
  }) async {
    await UserFileApi.moveFileList(userFileIdList: userFileIdList, newParentId: newParentId, keepUnique: keepUnique);
  }

  static Future<List<CommonResource>> getNormalFileList({
    required int parentId,
    int pageIndex = 0,
    int pageSize = NetConfig.commonPageSize,
  }) async {
    return await UserFileApi.getNormalFileList(parentId: parentId, pageIndex: pageIndex, pageSize: pageSize);
  }

  static Future<String> getDownloadUrl(int userFileId) async {
    return await UserFileApi.getDownloadUrl(userFileId);
  }
}
