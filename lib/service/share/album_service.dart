import 'package:file_client/api/client/share/album_api.dart';
import 'package:file_client/config/global.dart';
import 'package:file_client/model/share/album.dart';

class AlbumService {
  static Future<Album> createAlbum({
    String? topicId,
    required String title,
    required String introduction,
    required String coverUrl,
    required int albumType,
  }) async {
    if (Global.user.id == null) throw const FormatException("登录信息有误");
    var album = await AlbumApi.createAlbum(
      topicId: topicId,
      userId: Global.user.id!,
      title: title,
      introduction: introduction,
      coverUrl: coverUrl,
      albumType: albumType,
    );
    return album;
  }

  static Future<void> deleteAlbum({
    required String albumId,
  }) async {
    await AlbumApi.deleteAlbum(albumId: albumId);
  }

  static Future<void> updateAlbum({
    required String albumId,
    required String title,
    required String introduction,
    required String coverUrl,
  }) async {
    await AlbumApi.updateAlbum(albumId: albumId, title: title, introduction: introduction, coverUrl: coverUrl);
  }

  static Future<List<Album>> searchAlbum({
    required String keyword,
    required int page,
    required int pageSize,
  }) async {
    var list = await AlbumApi.searchAlbum(keyword: keyword, pageIndex: page, pageSize: pageSize);
    return list;
  }

  static Future<List<Album>> getFeedAlbum({
    required int pageSize,
  }) async {
    var list = await AlbumApi.getFeedAlbum(pageSize: pageSize);
    return list;
  }

  static Future<List<Album>> getUserAlbumList({
    required int albumType,
    required int pageIndex,
    required int pageSize,
    required bool withTopic,
  }) async {
    var list = await AlbumApi.getUserAlbumList(albumType: albumType, pageIndex: pageIndex, pageSize: pageSize,withTopic: withTopic);
    return list;
  }

  static Future<List<Album>> getSubscribeAlbumList({
    required int albumType,
    required int pageIndex,
    required int pageSize,
  }) async {
    var list = await AlbumApi.getSubscribeAlbumList(albumType: albumType, pageIndex: pageIndex, pageSize: pageSize);
    return list;
  }

  static Future<List<Album>> getAlbumListByTopic({
    required String topicId,
  }) async {
    var list = await AlbumApi.getAlbumListByTopic(topicId: topicId);
    return list;
  }
}
