import 'package:file_client/api/client/share/album_api.dart';
import 'package:file_client/api/client/share/application_api.dart';
import 'package:file_client/api/client/share/audio_api.dart';
import 'package:file_client/api/client/share/video_api.dart';
import 'package:file_client/config/global.dart';
import 'package:file_client/model/share/album.dart';
import 'package:file_client/model/share/application.dart';
import 'package:file_client/model/share/video.dart';

import '../../model/share/audio.dart';

class VideoService {
  static Future<Video> createVideo({
    required String albumId,
    required int fileId,
    required String title,
    String? coverUrl,
    int order = 0,
  }) async {
    if (Global.user.id == null) throw const FormatException("登录信息有误");
    var audio = await VideoApi.createVideo(
      albumId: albumId,
      fileId: fileId,
      title: title,
      coverUrl: coverUrl,
      order: order,
    );
    return audio;
  }

  static Future<void> deleteVideo({
    required String videoId,
  }) async {
    await VideoApi.deleteVideo(videoId: videoId);
  }

  static Future<void> updateVideo({
    required String videoId,
    required int fileId,
    required String title,
    required String? coverUrl,
    int order = 0,
  }) async {
    await VideoApi.updateVideo(
      videoId: videoId,
      fileId: fileId,
      title: title,
      coverUrl: coverUrl,
      order: order
    );
  }

  static Future<List<Video>> searchVideo({
    required String keyword,
    required int page,
    required int pageSize,
  }) async {
    var list = await VideoApi.searchVideo(keyword: keyword, pageIndex: page, pageSize: pageSize);
    return list;
  }

  static Future<List<Video>> getFeedVideo({
    required int pageSize,
  }) async {
    var list = await VideoApi.getFeedVideo(pageSize: pageSize);
    return list;
  }

  static Future<List<Video>> getVideoListByAlbum({
    required String albumId,
    required int pageIndex,
    required int pageSize,
  }) async {
    var list = await VideoApi.getVideoListByAlbum(pageSize: pageSize, albumId: albumId, pageIndex: pageIndex);
    return list;
  }
}
