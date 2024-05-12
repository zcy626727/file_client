import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../config/http_status_code.dart';
import '../../../model/common/common_resource.dart';
import '../../../model/file/share.dart';
import '../../../model/file/user_file.dart';
import '../../../model/file/user_folder.dart';
import '../file_http_config.dart';

class ShareApi {
  static Future<Share> createShare(
    List<UserFile> userFileList,
    List<UserFolder> userFolderList,
    DateTime endTime,
    String code,
    String name,
  ) async {
    List<String> userFileJsonList = [];
    for (var userFile in userFileList) {
      userFileJsonList.add(json.encode(userFile));
    }
    List<String> userFolderJsonList = [];
    for (var userFolder in userFolderList) {
      userFolderJsonList.add(json.encode(userFolder));
    }

    var r = await FileHttpConfig.dio.post(
      "/share/createShare",
      data: FormData.fromMap({
        "userFileList": userFileJsonList,
        "userFolderList": userFolderJsonList,
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

  static Future<List<Share>> getShareList() async {
    var r = await FileHttpConfig.dio.get(
      "/share/getShareList",
      queryParameters: {},
      options: FileHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
    List<Share> shareList = [];
    for (var shareJson in r.data['shareList']) {
      shareList.add(Share.fromJson(shareJson));
    }
    return shareList;
  }

  static Future<List<UserFolder>> getFolderPathInShare(
    int shareId,
    String? code,
    int folderId,
  ) async {
    var r = await FileHttpConfig.dio.get(
      "/share/getFolderPathInShare",
      queryParameters: {
        "shareId": shareId,
        "code": code,
        "folderId": folderId,
      },
      options: FileHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
    List<UserFolder> folderList = [];
    for (var folderJson in r.data['shareList']) {
      folderList.add(UserFolder.fromJson(folderJson));
    }
    return folderList;
  }

  static Future<String> deleteShare(int shareId) async {
    var r = await FileHttpConfig.dio.post(
      "/share/deleteShare",
      data: FormData.fromMap({
        "shareId": shareId,
      }),
      options: FileHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
    return r.data['message'];
  }

  static Future<String> updateShareStatus(int shareId, int newStatus) async {
    var r = await FileHttpConfig.dio.post(
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
    return r.data['message'];
  }

  static Future<Share> getShareByToken(String token) async {
    var r = await FileHttpConfig.dio.get(
      "/share/getShareByToken",
      queryParameters: {
        "token": token,
      },
      options: FileHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": false,
      }),
    );
    return Share.fromJson(r.data['share']);
  }

  static Future<(String, List<CommonResource>)> getShareData(
    int shareId,
    String? code,
    int? folderId,
  ) async {
    var r = await FileHttpConfig.dio.get(
      "/share/getShareData",
      queryParameters: {
        "shareId": shareId,
        "code": code,
        "folderId": folderId ?? 0,
      },
      options: FileHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": false,
      }),
    );

    List<CommonResource> resourceList = [];
    if (r.data['code'] != HttpStatusCode.success) {
      return (r.data['code'] as String, resourceList);
    }
    for (var userFileJson in r.data['userFileList']) {
      resourceList.add(UserFile.fromJson(userFileJson));
    }
    for (var userFolderJson in r.data['userFolderList']) {
      resourceList.add(UserFolder.fromJson(userFolderJson));
    }
    //获取数据
    return (r.data['code'] as String, resourceList);
  }

  static Future<String> saveResourceList(
    List<UserFile> userFileList,
    List<UserFolder> userFolderList,
    int shareId,
    String? code,
    int targetFolderId,
    bool isShareRoot,
  ) async {
    List<String> userFileJsonList = [];
    for (var userFile in userFileList) {
      userFileJsonList.add(json.encode(userFile));
    }
    List<String> userFolderJsonList = [];
    for (var userFolder in userFolderList) {
      userFolderJsonList.add(json.encode(userFolder));
    }
    var r = await FileHttpConfig.dio.post(
      "/share/saveResourceList",
      data: FormData.fromMap({
        "userFileList": userFileJsonList,
        "userFolderList": userFolderJsonList,
        "shareId": shareId,
        "code": code,
        "targetFolderId": targetFolderId,
        "isShareRoot": isShareRoot,
      }),
      options: FileHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
    if (HttpStatusCode.error == r.data['code']) {
      throw FormatException(r.data['message']);
    }
    //获取数据
    return r.data['message'];
  }
}
