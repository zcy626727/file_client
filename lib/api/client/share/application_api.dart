import 'package:dio/dio.dart';
import 'package:file_client/model/share/application.dart';

import '../share_http_config.dart';

class ApplicationApi {
  static Future<Application> createApplication({
    required String albumId,
    required int fileId,
    required String title,
    required String? introduction,
    required String? coverUrl,
    required int? version,
    required int? order,
  }) async {
    var r = await ShareHttpConfig.dio.post(
      "/application/createApplication",
      data: FormData.fromMap({
        "albumId": albumId,
        "fileId": fileId,
        "title": title,
        "introduction": introduction,
        "coverUrl": coverUrl,
        "version": version,
        "order": order,
      }),
      options: ShareHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );

    //获取数据
    return Application.fromJson(r.data['application']);
  }

  static Future<void> deleteApplication({
    required int applicationId,
  }) async {
    var r = await ShareHttpConfig.dio.post(
      "/application/deleteApplication",
      data: FormData.fromMap({
        "applicationId": applicationId,
      }),
      options: ShareHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
  }

  static Future<void> updateApplication({
    required int applicationId,
    required String title,
    required String introduction,
    required String coverUrl,
    required int order,
  }) async {
    var r = await ShareHttpConfig.dio.post(
      "/application/updateApplication",
      data: FormData.fromMap({
        "applicationId": applicationId,
        "title": title,
        "introduction": introduction,
        "coverUrl": coverUrl,
        "order": order,
      }),
      options: ShareHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
  }

  static Future<List<Application>> searchApplication({
    required int keyword,
    required String pageIndex,
    required String pageSize,
  }) async {
    var r = await ShareHttpConfig.dio.get(
      "/application/searchApplication",
      queryParameters: {
        "keyword": keyword,
        "pageIndex": pageIndex,
        "pageSize": pageSize,
      },
      options: ShareHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": false,
      }),
    );
    List<Application> albumList = [];
    for (var albumJson in r.data['applicationList']) {
      albumList.add(Application.fromJson(albumJson));
    }
    return albumList;
  }

  static Future<List<Application>> getFeedApplication({
    required String pageSize,
  }) async {
    var r = await ShareHttpConfig.dio.get(
      "/application/getFeedApplication",
      queryParameters: {
        "pageSize": pageSize,
      },
      options: ShareHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": false,
      }),
    );
    List<Application> applicationList = [];
    for (var applicationJson in r.data['applicationList']) {
      applicationList.add(Application.fromJson(applicationJson));
    }
    return applicationList;
  }

  static Future<List<Application>> getApplicationListByAlbum({
    required String albumId,
    required int pageIndex,
    required int pageSize,
  }) async {
    var r = await ShareHttpConfig.dio.get(
      "/video/getApplicationListByAlbum",
      queryParameters: {
        "albumId": albumId,
        "pageIndex": pageIndex,
        "pageSize": pageSize,
      },
      options: ShareHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": false,
      }),
    );
    List<Application> list = [];
    for (var json in r.data['applicationList']) {
      list.add(Application.fromJson(json));
    }
    return list;
  }
}
