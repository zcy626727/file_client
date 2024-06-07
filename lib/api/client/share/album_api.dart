import 'package:dio/dio.dart';
import 'package:file_client/model/share/album.dart';

import '../share_http_config.dart';

class AlbumApi {
  static Future<Album> createAlbum({
    String? topicId,
    required int userId,
    required String title,
    required String introduction,
    required String coverUrl,
    required int albumType,
  }) async {
    var r = await ShareHttpConfig.dio.post(
      "/album/createAlbum",
      data: FormData.fromMap({
        "topicId": topicId,
        "title": title,
        "introduction": introduction,
        "coverUrl": coverUrl,
        "albumType": albumType,
      }),
      options: ShareHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );

    //获取数据
    return Album.fromJson(r.data['album']);
  }

  static Future<void> deleteAlbum({
    required String albumId,
  }) async {
    await ShareHttpConfig.dio.post(
      "/album/deleteAlbum",
      data: FormData.fromMap({
        "albumId": albumId,
      }),
      options: ShareHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
  }

  static Future<void> updateAlbum({
    required String albumId,
    required String title,
    required String introduction,
    required String coverUrl,
  }) async {
    await ShareHttpConfig.dio.post(
      "/album/updateAlbum",
      data: FormData.fromMap({
        "albumId": albumId,
        "title": title,
        "introduction": introduction,
        "coverUrl": coverUrl,
      }),
      options: ShareHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
  }

  static Future<List<Album>> searchAlbum({
    required String keyword,
    required int pageIndex,
    required int pageSize,
  }) async {
    var r = await ShareHttpConfig.dio.get(
      "/album/searchAlbum",
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
    List<Album> albumList = [];
    for (var albumJson in r.data['albumList']) {
      albumList.add(Album.fromJson(albumJson));
    }
    return albumList;
  }

  static Future<List<Album>> getFeedAlbum({
    required int pageSize,
  }) async {
    var r = await ShareHttpConfig.dio.get(
      "/album/getFeedAlbum",
      queryParameters: {
        "pageSize": pageSize,
      },
      options: ShareHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": false,
      }),
    );
    List<Album> albumList = [];
    for (var albumJson in r.data['albumList']) {
      albumList.add(Album.fromJson(albumJson));
    }
    return albumList;
  }

  static Future<List<Album>> getSubscribeAlbumList({
    required int albumType,
    required int pageIndex,
    required int pageSize,
  }) async {
    var r = await ShareHttpConfig.dio.get(
      "/album/getSubscribeAlbumList",
      queryParameters: {
        "albumType": albumType,
        "pageIndex": pageIndex,
        "pageSize": pageSize,
      },
      options: ShareHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
    List<Album> albumList = [];
    for (var albumJson in r.data['albumList']) {
      albumList.add(Album.fromJson(albumJson));
    }
    return albumList;
  }

  static Future<List<Album>> getUserAlbumList({
    required int albumType,
    required int pageIndex,
    required int pageSize,
    required bool withTopic,
  }) async {
    var r = await ShareHttpConfig.dio.get(
      "/album/getUserAlbumList",
      queryParameters: {
        "albumType": albumType,
        "pageIndex": pageIndex,
        "pageSize": pageSize,
        "withTopic": withTopic,
      },
      options: ShareHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
    List<Album> albumList = [];
    for (var albumJson in r.data['albumList']) {
      albumList.add(Album.fromJson(albumJson));
    }
    return albumList;
  }

  static Future<List<Album>> getAlbumListByTopic({
    required String topicId,
  }) async {
    var r = await ShareHttpConfig.dio.get(
      "/album/getAlbumListByTopic",
      queryParameters: {
        "topicId": topicId,
      },
      options: ShareHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
    List<Album> albumList = [];
    for (var albumJson in r.data['albumList']) {
      albumList.add(Album.fromJson(albumJson));
    }
    return albumList;
  }
}
