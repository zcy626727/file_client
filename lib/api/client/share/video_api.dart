import 'package:dio/dio.dart';

import '../../../model/share/video.dart';
import '../share_http_config.dart';

class VideoApi {
  static Future<Video> createVideo({
    required String albumId,
    required int fileId,
    required String title,
    required String? coverUrl,
    required int order,
  }) async {
    var r = await ShareHttpConfig.dio.post(
      "/video/createVideo",
      data: FormData.fromMap({
        "albumId": albumId,
        "fileId": fileId,
        "title": title,
        "coverUrl": coverUrl,
        "order": order,
      }),
      options: ShareHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );

    //获取数据
    return Video.fromJson(r.data['video']);
  }

  static Future<void> deleteVideo({
    required String videoId,
  }) async {
    await ShareHttpConfig.dio.post(
      "/video/deleteVideo",
      data: FormData.fromMap({
        "videoId": videoId,
      }),
      options: ShareHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
  }

  static Future<void> updateVideo({
    required String videoId,
    required int fileId,
    required String title,
    required String? coverUrl,
    required int order,
  }) async {
    await ShareHttpConfig.dio.post(
      "/video/updateVideo",
      data: FormData.fromMap({
        "videoId": videoId,
        "fileId": fileId,
        "title": title,
        "coverUrl": coverUrl,
        "order": order,
      }),
      options: ShareHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
  }

  static Future<List<Video>> searchVideo({
    required String keyword,
    required int pageIndex,
    required int pageSize,
  }) async {
    var r = await ShareHttpConfig.dio.get(
      "/video/searchVideo",
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
    List<Video> videoList = [];
    for (var videoJson in r.data['videoList']) {
      videoList.add(Video.fromJson(videoJson));
    }
    return videoList;
  }

  static Future<List<Video>> getFeedVideo({
    required int pageSize,
  }) async {
    var r = await ShareHttpConfig.dio.get(
      "/video/getFeedVideo",
      queryParameters: {
        "pageSize": pageSize,
      },
      options: ShareHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": false,
      }),
    );
    List<Video> videoList = [];
    for (var videoJson in r.data['videoList']) {
      videoList.add(Video.fromJson(videoJson));
    }
    return videoList;
  }

  static Future<List<Video>> getVideoListByAlbum({
    required String albumId,
    required int pageIndex,
    required int pageSize,
  }) async {
    var r = await ShareHttpConfig.dio.get(
      "/video/getVideoListByAlbum",
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
    List<Video> list = [];
    for (var galleryJson in r.data['videoList']) {
      list.add(Video.fromJson(galleryJson));
    }
    return list;
  }
}
