import 'package:dio/dio.dart';

import '../../../model/share/audio.dart';
import '../share_http_config.dart';

class AudioApi {
  static Future<Audio> createAudio({
    required String albumId,
    required int fileId,
    required String title,
    required String? coverUrl,
    required int order,
  }) async {
    var r = await ShareHttpConfig.dio.post(
      "/audio/createAudio",
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
    return Audio.fromJson(r.data['audio']);
  }

  static Future<void> deleteAudio({
    required String audioId,
  }) async {
    await ShareHttpConfig.dio.post(
      "/audio/deleteAudio",
      data: FormData.fromMap({
        "audioId": audioId,
      }),
      options: ShareHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
  }

  static Future<void> updateAudio({
    required String audioId,
    required int fileId,
    required int order,
    required String title,
    required String? coverUrl,
  }) async {
    await ShareHttpConfig.dio.post(
      "/audio/updateAudio",
      data: FormData.fromMap({
        "audioId": audioId,
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

  static Future<List<Audio>> searchAudio({
    required String keyword,
    required int pageIndex,
    required int pageSize,
  }) async {
    var r = await ShareHttpConfig.dio.get(
      "/audio/searchAudio",
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
    List<Audio> audioList = [];
    for (var audioJson in r.data['audioList']) {
      audioList.add(Audio.fromJson(audioJson));
    }
    return audioList;
  }

  static Future<List<Audio>> getFeedAudio({
    required int pageSize,
  }) async {
    var r = await ShareHttpConfig.dio.get(
      "/audio/getFeedAudio",
      queryParameters: {
        "pageSize": pageSize,
      },
      options: ShareHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": false,
      }),
    );
    List<Audio> audioList = [];
    for (var audioJson in r.data['audioList']) {
      audioList.add(Audio.fromJson(audioJson));
    }
    return audioList;
  }

  static Future<List<Audio>> getAudioListByAlbum({
    required String albumId,
    required int pageIndex,
    required int pageSize,
  }) async {
    var r = await ShareHttpConfig.dio.get(
      "/audio/getAudioListByAlbum",
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
    List<Audio> list = [];
    for (var galleryJson in r.data['audioList']) {
      list.add(Audio.fromJson(galleryJson));
    }
    return list;
  }
}
