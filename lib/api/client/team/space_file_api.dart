import 'package:dio/dio.dart';
import 'package:file_client/model/common/common_resource.dart';
import 'package:file_client/model/space/space_file.dart';
import 'package:file_client/model/space/space_folder.dart';

import '../../../constant/file.dart';
import '../team_http_config.dart';

class SpaceFileApi {
  static Future<SpaceFile> createFile({
    required int parentId,
    required int spaceId,
    required int fileId,
    required String filename,
  }) async {
    var r = await TeamHttpConfig.dio.post(
      "/spaceFile/createFile",
      data: FormData.fromMap({
        "parentId": parentId,
        "spaceId": spaceId,
        "fileId": fileId,
        "filename": filename,
      }),
      options: TeamHttpConfig.options.copyWith(
        extra: {
          "noCache": true,
          "withToken": true,
        },
      ),
    );

    return SpaceFile.fromJson(r.data['spaceFile']);
  }

  static Future<SpaceFolder> createFolder({
    required int parentId,
    required int spaceId,
    required String folderName,
  }) async {
    var r = await TeamHttpConfig.dio.post(
      "/spaceFile/createFolder",
      data: FormData.fromMap({
        "parentId": parentId,
        "spaceId": spaceId,
        "folderName": folderName,
      }),
      options: TeamHttpConfig.options.copyWith(
        extra: {
          "noCache": true,
          "withToken": true,
        },
      ),
    );

    return SpaceFolder.fromJson(r.data['spaceFolder']);
  }

  //批量删除
  static Future<void> deleteFile({
    required int spaceFileId,
  }) async {
    await TeamHttpConfig.dio.delete(
      "/spaceFile/deleteFile",
      queryParameters: {
        "spaceFileId": spaceFileId,
      },
      options: TeamHttpConfig.options.copyWith(
        extra: {
          "noCache": true,
          "withToken": true,
        },
      ),
    );
  }

  static Future<void> deleteFileList({
    required List<int> spaceFileIdList,
  }) async {
    await TeamHttpConfig.dio.delete(
      "/spaceFile/deleteFileList",
      queryParameters: {
        "spaceFileIdList": spaceFileIdList,
      },
      options: TeamHttpConfig.options.copyWith(
        extra: {
          "noCache": true,
          "withToken": true,
        },
      ),
    );
  }

  static Future<void> renameFile({
    required int spaceFileId,
    required String newName,
  }) async {
    await TeamHttpConfig.dio.put(
      "/spaceFile/renameFile",
      data: FormData.fromMap({
        "spaceFileId": spaceFileId,
        "newName": newName,
      }),
      options: TeamHttpConfig.options.copyWith(
        extra: {
          "noCache": true,
          "withToken": true,
        },
      ),
    );
  }

  static Future<void> moveFile({
    required int spaceFileId,
    required int newParentId,
  }) async {
    await TeamHttpConfig.dio.put(
      "/spaceFile/moveFile",
      data: FormData.fromMap({
        "spaceFileId": spaceFileId,
        "newParentId": newParentId,
      }),
      options: TeamHttpConfig.options.copyWith(
        extra: {
          "noCache": true,
          "withToken": true,
        },
      ),
    );
  }

  static Future<void> moveFileList({
    required List<int> spaceFileIdList,
    required int newParentId,
  }) async {
    await TeamHttpConfig.dio.put(
      "/spaceFile/moveFileList",
      data: FormData.fromMap({
        "spaceFileIdList": spaceFileIdList,
        "newParentId": newParentId,
      }),
      options: TeamHttpConfig.options.copyWith(
        extra: {
          "noCache": true,
          "withToken": true,
        },
      ),
    );
  }

  static Future<void> updatePermission({
    required int spaceFileId,
    int? newGroupId,
    int? newGroupPermission,
    int? newOtherPermission,
  }) async {
    await TeamHttpConfig.dio.put(
      "/spaceFile/updatePermission",
      data: FormData.fromMap({
        "spaceFileId": spaceFileId,
        "newGroupId": newGroupId ?? 0,
        "newGroupPermission": newGroupPermission ?? 0,
        "newOtherPermission": newOtherPermission ?? 0,
      }),
      options: TeamHttpConfig.options.copyWith(
        extra: {
          "noCache": true,
          "withToken": true,
        },
      ),
    );
  }

  static Future<List<CommonResource>> getNormalFileList({
    required int parentId,
    required int spaceId,
    required int pageIndex,
    required int pageSize,
  }) async {
    var r = await TeamHttpConfig.dio.get(
      "/spaceFile/getNormalFileList",
      queryParameters: {
        "parentId": parentId,
        "spaceId": spaceId,
        "pageIndex": pageIndex,
        "pageSize": pageSize,
      },
      options: TeamHttpConfig.options.copyWith(
        extra: {
          "noCache": true,
          "withToken": true,
        },
      ),
    );
    return _parseSpaceFileList(r);
  }

  static Future<List<SpaceFolder>> getNormalFolderList({
    required int parentId,
    required int spaceId,
    required int pageIndex,
    required int pageSize,
  }) async {
    var r = await TeamHttpConfig.dio.get(
      "/spaceFile/getNormalFolderList",
      queryParameters: {
        "parentId": parentId,
        "spaceId": spaceId,
        "pageIndex": pageIndex,
        "pageSize": pageSize,
      },
      options: TeamHttpConfig.options.copyWith(
        extra: {
          "noCache": true,
          "withToken": true,
        },
      ),
    );
    return _parseSpaceFolderList(r);
  }

  //获取getUrl，文件下载
  static Future<String> getDownloadUrl({required int spaceFileId}) async {
    var r = await TeamHttpConfig.dio.get(
      "/spaceFile/getDownloadUrl",
      queryParameters: {
        "spaceFileId": spaceFileId,
      },
      options: TeamHttpConfig.options.copyWith(
        extra: {
          "noCache": true,
          "withToken": true,
        },
      ),
    );

    //获取数据
    return r.data["downloadUrl"];
  }

  static List<CommonResource> _parseSpaceFileList(Response<dynamic> r) {
    List<CommonResource> list = [];
    for (var map in r.data["spaceFileList"]) {
      if (map['fileType'] == FileType.direction) {
        //文件夹
        list.add(SpaceFolder.fromJson(map));
      } else {
        //文件
        list.add(SpaceFile.fromJson(map));
      }
    }
    return list;
  }

  static List<SpaceFolder> _parseSpaceFolderList(Response<dynamic> r) {
    List<SpaceFolder> list = [];
    for (var map in r.data["spaceFolderList"]) {
      if (map['fileType'] == FileType.direction) {
        //文件夹
        list.add(SpaceFolder.fromJson(map));
      }
    }
    return list;
  }
}
