import 'package:dio/dio.dart';
import 'package:file_client/constant/file.dart';
import 'package:file_client/model/common/common_resource.dart';
import 'package:file_client/model/file/user_folder.dart';

import '../../../model/file/user_file.dart';
import '../file_http_config.dart';

class UserFileApi {
  static Future<UserFile> createFile({
    required String filename,
    required int fileId,
    required int parentId,
  }) async {
    var r = await FileHttpConfig.dio.post(
      "/userFile/createFile",
      data: FormData.fromMap({
        "filename": filename,
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

  static Future<UserFolder> createFolder({
    required String folderName,
    required int parentId,
  }) async {
    var r = await FileHttpConfig.dio.post(
      "/userFile/createFolder",
      data: FormData.fromMap({
        "folderName": folderName,
        "parentId": parentId,
      }),
      options: FileHttpConfig.options.copyWith(
        extra: {
          "noCache": true,
          "withToken": true,
        },
      ),
    );
    return UserFolder.fromJson(r.data["userFolder"]);
  }

  //删除文件
  static Future<void> deleteFile({
    required int userFileId,
  }) async {
    var _ = await FileHttpConfig.dio.delete(
      "/userFile/deleteFile",
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
  }

  //删除文件
  static Future<void> deleteFileList({
    required List<int> userFileIdList,
  }) async {
    var _ = await FileHttpConfig.dio.delete(
      "/userFile/deleteFileList",
      queryParameters: {
        "userFileIdList": userFileIdList,
      },
      options: FileHttpConfig.options.copyWith(
        extra: {
          "noCache": true,
          "withToken": true,
        },
      ),
    );
  }

  //文件重命名
  static Future<void> renameFile({
    required int userFileId,
    required String newFilename,
  }) async {
    var _ = await FileHttpConfig.dio.put(
      "/userFile/renameFile",
      data: FormData.fromMap({
        "userFileId": userFileId,
        "newFilename": newFilename,
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
  static Future<void> moveFile({
    required int fileId,
    required int newParentId,
    required bool keepUnique,
  }) async {
    await FileHttpConfig.dio.put(
      "/userFile/moveFile",
      data: FormData.fromMap({
        "fileId": fileId,
        "newParentId": newParentId,
        "keepUnique": keepUnique,
      }),
      options: FileHttpConfig.options.copyWith(
        extra: {
          "noCache": true,
          "withToken": true,
        },
      ),
    );
  }

  static Future<void> moveFileList({
    required List<int> userFileIdList,
    required int newParentId,
    required bool keepUnique,
  }) async {
    await FileHttpConfig.dio.put(
      "/userFile/moveFileList",
      data: FormData.fromMap({
        "userFileIdList": userFileIdList,
        "newParentId": newParentId,
        "keepUnique": keepUnique,
      }),
      options: FileHttpConfig.options.copyWith(
        extra: {
          "noCache": true,
          "withToken": true,
        },
      ),
    );
  }

  static Future<List<CommonResource>> getNormalFileList({
    required int parentId,
    required int pageIndex,
    required int pageSize,
  }) async {
    var r = await FileHttpConfig.dio.get(
      "/userFile/getNormalFileList",
      queryParameters: {
        "parentId": parentId,
        "pageIndex": pageIndex,
        "pageSize": pageSize,
      },
      options: FileHttpConfig.options.copyWith(
        extra: {
          "noCache": true,
          "withToken": true,
        },
      ),
    );
    return _parseUserFileList(r);
  }

  static Future<List<CommonResource>> getFolderList({
    required int parentId,
    required int pageIndex,
    required int pageSize,
  }) async {
    var r = await FileHttpConfig.dio.get(
      "/userFile/getFolderList",
      queryParameters: {
        "parentId": parentId,
        "pageIndex": pageIndex,
        "pageSize": pageSize,
      },
      options: FileHttpConfig.options.copyWith(
        extra: {
          "noCache": true,
          "withToken": true,
        },
      ),
    );
    return _parseUserFileList(r);
  }

  //获取getUrl，文件下载
  static Future<String> getDownloadUrl({required int userFileId}) async {
    var r = await FileHttpConfig.dio.get(
      "/userFile/getDownloadUrl",
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
    return r.data["downloadUrl"];
  }

  //判断文件是否在目标文件夹下存在同名冲突
  static Future<bool> isFileNameUnique({
    required int userFileId,
    required int targetFolderId,
  }) async {
    var r = await FileHttpConfig.dio.post(
      "/userFile/isFileNameUnique",
      data: FormData.fromMap({
        "userFileId": userFileId,
        "targetFolderId": targetFolderId,
      }),
      options: FileHttpConfig.options.copyWith(
        extra: {
          "noCache": true,
          "withToken": true,
        },
      ),
    );
    return r.data['isUnique'];
  }

  //判断文件列表是否在目标文件夹下存在同名冲突
  static Future<bool> isFileListNameUnique({
    required List<int> userFileIdList,
    required int targetFolderId,
  }) async {
    var r = await FileHttpConfig.dio.post(
      "/userFile/isFileListNameUnique",
      data: FormData.fromMap({
        "userFileIdList": userFileIdList,
        "targetFolderId": targetFolderId,
      }),
      options: FileHttpConfig.options.copyWith(
        extra: {
          "noCache": true,
          "withToken": true,
        },
      ),
    );
    return r.data['isUnique'];
  }

  static List<CommonResource> _parseUserFileList(Response<dynamic> r) {
    List<CommonResource> list = [];
    for (var map in r.data["userFileList"]) {
      if (map['fileType'] == FileType.direction) {
        //文件夹
        list.add(UserFolder.fromJson(map));
      } else {
        //文件
        list.add(UserFile.fromJson(map));
      }
    }
    return list;
  }
}
