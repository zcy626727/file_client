import 'package:dio/dio.dart';
import 'package:file_client/model/common/common_resource.dart';
import 'package:file_client/model/file/user_file.dart';

import '../../../constant/file.dart';
import '../../../model/file/trash.dart';
import '../../../model/file/user_folder.dart';
import '../file_http_config.dart';

class TrashApi {
  //获取回收站列表
  static Future<List<Trash>> getTrashList({
    required int pageIndex,
    required int pageSize,
  }) async {
    var r = await FileHttpConfig.dio.get(
      "/trash/getTrashList",
      queryParameters: {
        "pageIndex": pageIndex,
        "pageSize": pageSize,
      },
      options: FileHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
    return _parseTrashFileList(r);
  }

  static Future<void> recoverTrash({
    required int trashId,
  }) async {
    await FileHttpConfig.dio.post(
      "/trash/recoverTrash",
      data: FormData.fromMap({
        "trashId": trashId,
      }),
      options: FileHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
  }

  static Future<void> recoverTrashList({
    required List<int> trashIdList,
  }) async {
    await FileHttpConfig.dio.post(
      "/trash/recoverTrashList",
      data: FormData.fromMap({
        "trashIdList": trashIdList,
      }),
      options: FileHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
  }

  //彻底删除
  static Future<void> deleteTrash({
    required int trashId,
  }) async {
    await FileHttpConfig.dio.delete(
      "/trash/deleteTrash",
      queryParameters: {
        "trashId": trashId,
      },
      options: FileHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
  }

  static Future<void> deleteTrashList({
    required List<int> trashIdList,
  }) async {
    await FileHttpConfig.dio.delete(
      "/trash/deleteTrashList",
      queryParameters: {
        "trashIdList": trashIdList,
      },
      options: FileHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
  }

  static List<Trash> _parseTrashFileList(Response<dynamic> r) {
    var fileMap = <int?, CommonResource>{};
    for (var map in r.data["userFileList"]) {
      if (map['fileType'] == FileType.direction) {
        var userFolder = UserFolder.fromJson(map);
        fileMap[userFolder.id] = userFolder;
      } else {
        var userFile = UserFile.fromJson(map);
        fileMap[userFile.id] = userFile;
      }
    }
    List<Trash> list = [];
    for (var map in r.data["trashList"]) {
      var trash = Trash.fromJson(map);
      trash.file = fileMap[trash.userFileId];
      list.add(trash);
    }
    return list;
  }
}
