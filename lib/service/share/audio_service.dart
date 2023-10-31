import 'package:file_client/api/client/share/album_api.dart';
import 'package:file_client/api/client/share/application_api.dart';
import 'package:file_client/api/client/share/audio_api.dart';
import 'package:file_client/config/global.dart';
import 'package:file_client/model/share/album.dart';
import 'package:file_client/model/share/application.dart';

import '../../model/share/audio.dart';

class AudioService {
  static Future<Audio> createAudio({
    required String albumId,
    required int fileId,
    required String title,
    required String? coverUrl,
    int order = 0,
  }) async {
    if (Global.user.id == null) throw const FormatException("登录信息错误");
    var audio = await AudioApi.createAudio(
      albumId: albumId,
      fileId: fileId,
      title: title,
      coverUrl: coverUrl,
      order: order,
    );
    return audio;
  }

  static Future<void> deleteAudio({
    required String audioId,
  }) async {
    await AudioApi.deleteAudio(audioId: audioId);
  }

  static Future<void> updateAudio({
    required String audioId,
    required int fileId,
    required String title,
    required String? coverUrl,
    int order = 0,
  }) async {
    await AudioApi.updateAudio(
      audioId: audioId,
      fileId: fileId,
      title: title,
      coverUrl: coverUrl,
      order: order,
    );
  }

  static Future<List<Audio>> searchAudio({
    required String keyword,
    required int page,
    required int pageSize,
  }) async {
    var list = await AudioApi.searchAudio(keyword: keyword, pageIndex: page, pageSize: pageSize);
    return list;
  }

  static Future<List<Audio>> getFeedAudio({
    required int pageSize,
  }) async {
    var list = await AudioApi.getFeedAudio(pageSize: pageSize);
    return list;
  }

  static Future<List<Audio>> getAudioListByAlbum({
    required String albumId,
    required int pageIndex,
    required int pageSize,
  }) async {
    var list = await AudioApi.getAudioListByAlbum(pageSize: pageSize, albumId: albumId, pageIndex: pageIndex);
    return list;
  }
}
