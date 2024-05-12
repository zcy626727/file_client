import 'dart:io';

import '../../api/client/file/user_file_api.dart';
import '../../config/file_config.dart';
import '../../constant/file.dart';
import '../../domain/task/download_task.dart';
import '../../domain/task/multipart_upload_task.dart';
import '../../model/file/user_file.dart';
import '../../util/file_util.dart';

class UserFileService {
  static Future<void> uploadFile(MultipartUploadTask task) async {
    final file = File(task.srcPath!);
    var md5 = await FileUtil.getFileChecksum(file);
    if (md5 == null) {
      throw Exception("文件解析失败");
    }
    //文件不能过大
    var fileStat = await file.stat();
    if (fileStat.size > FileConfig.maxUploadFileSize) {
      //todo 标记文件过大
      throw Exception("文件不能大于4G");
    }
    FileUtil.uploadFile(file.path, file.readAsBytesSync());
    task.md5 = md5;
  }

  static Future<String> genGetFileUrl(int userFileId) async {
    return await UserFileApi.genGetFileUrl(userFileId);
  }

  static Future<UserFile> createFile(String fileName, int fileId, int parentId) async {
    var userFile = await UserFileApi.createFile(fileName, fileId, parentId);
    return userFile;
  }

  static Future<void> downloadFile(DownloadTask task) async {}

  static Future<void> deleteFile(int folderId) async {
    await UserFileApi.deleteFile(folderId);
  }

  static Future<void> renameFile({
    required int folderId,
    required String newFolderName,
    required String oldFolderName,
  }) async {
    await UserFileApi.renameFile(folderId, newFolderName, oldFolderName);
  }

  static Future<List<UserFile>> getFileList({
    required int parentId,
    required List<int> statusList,
    int fileType = FileType.any,
  }) async {
    return await UserFileApi.getFileList(parentId: parentId, statusList: statusList, fileType: fileType);
  }

  static Future<void> moveFile({
    required int fileId,
    required int oldParentId,
    required int newParentId,
  }) async {
    await UserFileApi.moveFile(fileId, oldParentId, newParentId);
  }
}
