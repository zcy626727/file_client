import 'package:file_client/config/net_config.dart';
import 'package:file_client/model/space/space_file.dart';

import '../../api/client/team/space_file_api.dart';
import '../../model/common/common_resource.dart';
import '../../model/space/space_folder.dart';

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

  static Future<SpaceFolder> createFolder({
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

  static Future<List<CommonResource>> getNormalFileList({
    required int parentId,
    required int spaceId,
    int pageIndex = 0,
    int pageSize = NetConfig.commonPageSize,
  }) async {
    return await SpaceFileApi.getNormalFileList(
      parentId: parentId,
      pageIndex: pageIndex,
      pageSize: pageSize,
      spaceId: spaceId,
    );
  }

  static Future<List<SpaceFolder>> getNormalFolderList({
    required int parentId,
    required int spaceId,
    int pageIndex = 0,
    int pageSize = NetConfig.commonPageSize,
  }) async {
    return await SpaceFileApi.getNormalFolderList(
      parentId: parentId,
      pageIndex: pageIndex,
      pageSize: pageSize,
      spaceId: spaceId,
    );
  }

  static Future<String> getDownloadUrl({required int spaceFileId}) async {
    return await SpaceFileApi.getDownloadUrl(spaceFileId: spaceFileId);
  }
}
