import 'package:dio/dio.dart';

import '../../../domain/resource.dart';
import '../../../model/file/user_file.dart';
import '../file_http_config.dart';

class UserFileApi {
  //获取getUrl，文件下载
  static Future<String> genGetFileUrl(int userFileId) async {
    var r = await FileHttpConfig.dio.get(
      "/userFile/genGetFileUrl",
      queryParameters: {
        "userFileId": userFileId,
      },
      options: FileHttpConfig.options.copyWith(
        extra: {
          "noCache": true,
          "withToken": true,
        },
      ),
    );

    //获取数据
    return r.data["getFileUrl"];
  }

  static Future<UserFile> createFile(String fileName, int fileId, int parentId) async {
    var r = await FileHttpConfig.dio.post(
      "/userFile/createFile",
      data: FormData.fromMap({
        "fileName": fileName,
        "fileId": fileId,
        "parentId": parentId,
      }),
      options: FileHttpConfig.options.copyWith(
        extra: {
          "noCache": true,
          "withToken": true,
        },
      ),
    );
    return UserFile.fromJson(r.data["userFile"]);
  }

  //删除文件
  static Future<void> deleteFile(int fileId) async {
    var _ = await FileHttpConfig.dio.post(
      "/userFile/deleteFile",
      data: FormData.fromMap({
        "fileId": fileId,
      }),
      options: FileHttpConfig.options.copyWith(
        extra: {
          "noCache": true,
          "withToken": true,
        },
      ),
    );
  }

  //文件重命名
  static Future<void> renameFile(
    int folderId,
    String newFolderName,
    String oldFolderName,
  ) async {
    var _ = await FileHttpConfig.dio.post(
      "/userFile/renameFile",
      data: FormData.fromMap({
        "folderId": folderId,
        "newFolderName": newFolderName,
        "oldFolderName": oldFolderName,
      }),
      options: FileHttpConfig.options.copyWith(
        extra: {
          "noCache": true,
          "withToken": true,
        },
      ),
    );
  }

  static Future<List<UserFile>> getFileList({
    required int parentId,
    required List<int> statusList,
    required int fileType,
  }) async {
    var r = await FileHttpConfig.dio.get(
      "/userFile/getFileList",
      queryParameters: {
        "parentId": parentId,
        "statusList": statusList,
        "fileType": fileType,
      },
      options: FileHttpConfig.options.copyWith(
        extra: {
          "noCache": true,
          "withToken": true,
        },
      ),
    );

    var fileList = <UserFile>[];
    for (var map in r.data["fileList"]) {
      fileList.add(UserFile.fromJson(map));
    }
    return fileList;
  }

  //移动文件夹
  static Future<void> moveFile(
    int fileId,
    int oldParentId,
    int newParentId,
  ) async {
    var _ = await FileHttpConfig.dio.post(
      "/userFile/moveFile",
      data: FormData.fromMap({
        "fileId": fileId,
        "newParentId": newParentId,
        "oldParentId": oldParentId,
      }),
      options: FileHttpConfig.options.copyWith(
        extra: {
          "noCache": true,
          "withToken": true,
        },
      ),
    );
  }
}
