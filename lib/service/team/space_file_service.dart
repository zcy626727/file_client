import 'package:file_client/config/net_config.dart';
import 'package:file_client/model/space/space_file.dart';

import '../../api/client/team/space_file_api.dart';

class SpaceFileService {
  static Future<SpaceFile> createFile({
    required String filename,
    required int fileId,
    required int parentId,
    required int spaceId,
  }) async {
    var userFile = await SpaceFileApi.createFile(parentId: parentId, spaceId: spaceId, fileId: fileId, filename: filename);
    return userFile;
  }

  static Future<SpaceFile> createFolder({
    required String folderName,
    required int parentId,
    required int spaceId,
  }) async {
    var userFile = await SpaceFileApi.createFolder(parentId: parentId, spaceId: spaceId, folderName: folderName);
    return userFile;
  }

  static Future<void> deleteFile({
    required int spaceFileId,
  }) async {
    await SpaceFileApi.deleteFile(spaceFileId: spaceFileId);
  }

  static Future<void> deleteFileList({
    required List<int> spaceFileIdList,
  }) async {
    await SpaceFileApi.deleteFileList(spaceFileIdList: spaceFileIdList);
  }

  static Future<void> renameFile({
    required int spaceFileId,
    required String newName,
  }) async {
    await SpaceFileApi.renameFile(spaceFileId: spaceFileId, newName: newName);
  }

  static Future<void> moveFile({
    required int spaceFileId,
    required int newParentId,
  }) async {
    await SpaceFileApi.moveFile(spaceFileId: spaceFileId, newParentId: newParentId);
  }

  static Future<void> moveFileList({
    required List<int> spaceFileIdList,
    required int newParentId,
  }) async {
    await SpaceFileApi.moveFileList(spaceFileIdList: spaceFileIdList, newParentId: newParentId);
  }

  static Future<void> updatePermission({
    required int spaceFileId,
    required int newGroupId,
    required int newGroupPermission,
    required int newOtherPermission,
  }) async {
    await SpaceFileApi.updatePermission(
      spaceFileId: spaceFileId,
      newGroupId: newGroupId,
      newGroupPermission: newGroupPermission,
      newOtherPermission: newOtherPermission,
    );
  }

  static Future<void> getNormalFileList({
    required int parentId,
    int pageIndex = 0,
    int pageSize = NetConfig.commonPageSize,
  }) async {
    await SpaceFileApi.getNormalFileList(
      parentId: parentId,
      pageIndex: pageIndex,
      pageSize: pageSize,
    );
  }
}
