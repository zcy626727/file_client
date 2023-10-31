import 'package:dio/dio.dart';

import '../../../model/file/user_folder.dart';
import '../file_http_config.dart';

class UserFolderApi {
  //新建文件夹
  static Future<UserFolder> createFolder(int parentId, String folderName) async {
    var r = await FileHttpConfig.dio.post(
      "/userFolder/createFolder",
      data: FormData.fromMap({
        "parentId": parentId,
        "folderName": folderName,
      }),
      options: FileHttpConfig.options.copyWith(
        extra: {
          "noCache": true,
          "withToken": true,
        },
      ),
    );

    return UserFolder.fromJson(r.data["folder"]);
  }

  //删除文件夹
  static Future<void> deleteFolder(int folderId) async {
    var _ = await FileHttpConfig.dio.post(
      "/userFolder/deleteFolder",
      data: FormData.fromMap({
        "folderId": folderId,
      }),
      options: FileHttpConfig.options.copyWith(
        extra: {
          "noCache": true,
          "withToken": true,
        },
      ),
    );
  }

  //重命名文件夹
  static Future<void> renameFolder(
    int folderId,
    String newFolderName,
    String oldFolderName,
  ) async {
    var _ = await FileHttpConfig.dio.post(
      "/userFolder/renameFolder",
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

  //移动文件夹
  static Future<void> moveFolder(
    int folderId,
    int oldParentId,
    int newParentId,
  ) async {
    var _ = await FileHttpConfig.dio.post(
      "/userFolder/moveFolder",
      data: FormData.fromMap({
        "folderId": folderId,
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

  static Future<List<UserFolder>> getFolderList(
    int parentId,
    List<int> statusList,
  ) async {
    var r = await FileHttpConfig.dio.get(
      "/userFolder/getFolderList",
      queryParameters: {
        "parentId": parentId,
        "statusList": statusList,
      },
      options: FileHttpConfig.options.copyWith(
        extra: {
          "noCache": false,
          "withToken": true,
        },
      ),
    );

    List<UserFolder> userFolderList = [];
    for (var map in r.data["folderList"]) {
      userFolderList.add(UserFolder.fromJson(map));
    }
    return userFolderList;
  }
}
