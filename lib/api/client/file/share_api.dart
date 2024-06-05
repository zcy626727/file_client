import 'package:dio/dio.dart';

import '../../../model/file/share.dart';
import '../../../model/file/user_file.dart';
import '../file_http_config.dart';

class ShareApi {
  static Future<Share> createShare({
    required List<int> userFileIdList,
    required DateTime endTime,
    String? code,
    required String name,
  }) async {
    var r = await FileHttpConfig.dio.post(
      "/share/createShare",
      data: FormData.fromMap({
        "userFileList": userFileIdList,
        "endTime": endTime,
        "code": code,
        "name": name,
      }),
      options: FileHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );

    //获取数据
    return Share.fromJson(r.data['share']);
  }

  static Future<void> deleteShare({
    required int shareId,
  }) async {
    await FileHttpConfig.dio.delete(
      "/share/deleteShare",
      queryParameters: {
        "shareId": shareId,
      },
      options: FileHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
  }

  static Future<void> updateShareStatus({
    required int shareId,
    required int newStatus,
  }) async {
    await FileHttpConfig.dio.put(
      "/share/updateShareStatus",
      data: FormData.fromMap({
        "shareId": shareId,
        "newStatus": newStatus,
      }),
      options: FileHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
  }

  static Future<List<Share>> getShareList({
    required int pageIndex,
    required int pageSize,
  }) async {
    var r = await FileHttpConfig.dio.get(
      "/share/getShareList",
      queryParameters: {},
      options: FileHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
    return _parseShareList(r);
  }

  //获取自己分享的share信息
  static Future<Share> getShare({
    required int shareId,
  }) async {
    var r = await FileHttpConfig.dio.get(
      "/share/getShare",
      queryParameters: {
        "shareId": shareId,
      },
      options: FileHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": false,
      }),
    );
    return Share.fromJson(r.data['share']);
  }

  // 访问分享链接，校验并返回文件列表，如果出错可以根据状态码判断错误
  static Future<List<UserFile>> accessShare({
    required String token,
    String? code,
    int? folderId,
    required int pageIndex,
    required int pageSize,
  }) async {
    var r = await FileHttpConfig.dio.get(
      "/share/accessShare",
      queryParameters: {
        "token": token,
        "code": code,
        "folderId": folderId,
        "pageIndex": pageIndex,
        "pageSize": pageSize,
      },
      options: FileHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
    return _parseUserFileList(r);
  }

  // 将文件列表保存到自己的网盘中
  static Future<void> saveFileList({
    required String token,
    String? code,
    required List<int> userFileIdList,
    required int targetFolderId,
  }) async {
    await FileHttpConfig.dio.get(
      "/share/saveFileList",
      queryParameters: {
        "token": token,
        "code": code,
        "userFileIdList": userFileIdList,
        "targetFolderId": targetFolderId,
      },
      options: FileHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
  }

  static List<Share> _parseShareList(Response<dynamic> r) {
    List<Share> shareList = [];
    for (var json in r.data['shareList']) {
      shareList.add(Share.fromJson(json));
    }
    return shareList;
  }

  static List<UserFile> _parseUserFileList(Response<dynamic> r) {
    List<UserFile> list = [];
    for (var map in r.data["userFileList"]) {
      list.add(UserFile.fromJson(map));
    }
    return list;
  }
}
