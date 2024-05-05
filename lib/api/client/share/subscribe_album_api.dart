import 'package:dio/dio.dart';
import 'package:file_client/model/share/subscribe_album.dart';

import '../share_http_config.dart';

class SubscribeAlbumApi {
  static Future<SubscribeAlbum> createSubscribe({
    required String albumId,
  }) async {
    var r = await ShareHttpConfig.dio.post(
      "/subscribeAlbum/createSubscribe",
      data: FormData.fromMap({
        "albumId": albumId,
      }),
      options: ShareHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );

    //获取数据
    return SubscribeAlbum.fromJson(r.data['subscribeAlbum']);
  }

  static Future<void> deleteSubscribe({
    required String subscribeId,
  }) async {
    var r = await ShareHttpConfig.dio.post(
      "/subscribeAlbum/deleteSubscribe",
      data: FormData.fromMap({
        "subscribeId": subscribeId,
      }),
      options: ShareHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
  }

  static Future<SubscribeAlbum?> getUserSubscribeAlbumInfo({
    required String albumId,
  }) async {
    var r = await ShareHttpConfig.dio.get(
      "/subscribeAlbum/getUserSubscribeAlbumInfo",
      queryParameters: {
        "albumId": albumId,
      },
      options: ShareHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
    //获取数据
    var json = r.data['subscribeAlbum'];
    if (json == null) return null;
    return SubscribeAlbum.fromJson(json);
  }
}
