import 'package:dio/dio.dart';

import '../../../constant/resource.dart';
import '../../../model/file/trash.dart';
import '../file_http_config.dart';

class TrashApi {
  //获取回收站列表
  static Future<List<Trash>> getTrashList() async {
    var r = await FileHttpConfig.dio.get(
      "/trash/getTrashList",
      queryParameters: {
        "typeList": [ResourceType.folder.index, ResourceType.file.index],
      },
      options: FileHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
    List<Trash> trashList = [];
    for (var trashJson in r.data['trashList']) {
      trashList.add(Trash.fromJson(trashJson));
    }
    //获取数据
    return trashList;
  }

  //恢复文件
  static Future<String> recoverItem(int trashId) async {
    var r = await FileHttpConfig.dio.post(
      "/trash/recoverItem",
      data: FormData.fromMap({
        "trashId": trashId,
      }),
      options: FileHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
    //获取数据
    return r.data['message'];
  }

  //彻底删除文件
  static Future<String> deleteItem(int trashId) async {
    var r = await FileHttpConfig.dio.post(
      "/trash/deleteItem",
      data: FormData.fromMap({
        "trashId": trashId,
      }),
      options: FileHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
    //获取数据
    return r.data['message'];
  }
}