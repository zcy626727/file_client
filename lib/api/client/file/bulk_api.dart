import 'package:dio/dio.dart';

import '../file_http_config.dart';

class BulkApi {
  static Future<void> moveResourceList(
    int oldParentId,
    int newParentId,
    List<int> userFileIdList,
    List<int> userFolderIdList,
  ) async {
    var r = await FileHttpConfig.dio.post(
      "/bulk/moveResourceList",
      data: FormData.fromMap({
        "oldParentId": oldParentId,
        "newParentId": newParentId,
        "userFileIdList": userFileIdList,
        "userFolderIdList": userFolderIdList,
      }),
      options: FileHttpConfig.options.copyWith(
        extra: {
          "noCache": true,
          "withToken": true,
        },
      ),
    );
  }

  static Future<void> deleteResourceList(
    List<int> userFileIdList,
    List<int> userFolderIdList,
  ) async {
    var r = await FileHttpConfig.dio.post(
      "/bulk/deleteResourceList",
      data: FormData.fromMap({
        "userFileIdList": userFileIdList,
        "userFolderIdList": userFolderIdList,
      }),
      options: FileHttpConfig.options.copyWith(
        extra: {
          "noCache": true,
          "withToken": true,
        },
      ),
    );
  }

  static Future<void> recoverTrashItemList(
    List<int> trashIdList,
  ) async {
    var r = await FileHttpConfig.dio.post(
      "/bulk/recoverTrashItemList",
      data: FormData.fromMap({
        "trashIdList": trashIdList,
      }),
      options: FileHttpConfig.options.copyWith(
        extra: {
          "noCache": true,
          "withToken": true,
        },
      ),
    );
  }

  static Future<void> deleteTrashItemList(
    List<int> trashIdList,
  ) async {
    var r = await FileHttpConfig.dio.post(
      "/bulk/deleteTrashItemList",
      data: FormData.fromMap({
        "trashIdList": trashIdList,
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
