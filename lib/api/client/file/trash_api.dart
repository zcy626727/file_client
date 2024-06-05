import 'package:dio/dio.dart';

import '../../../model/file/trash.dart';
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
    List<Trash> list = [];
    for (var map in r.data["trashList"]) {
      list.add(Trash.fromJson(map));
    }
    return list;
  }
}
