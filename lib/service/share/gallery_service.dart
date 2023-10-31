import 'package:file_client/api/client/share/album_api.dart';
import 'package:file_client/api/client/share/application_api.dart';
import 'package:file_client/api/client/share/audio_api.dart';
import 'package:file_client/api/client/share/gallery_api.dart';
import 'package:file_client/config/global.dart';
import 'package:file_client/model/share/album.dart';
import 'package:file_client/model/share/application.dart';
import 'package:file_client/model/share/gallery.dart';

import '../../model/share/audio.dart';

class GalleryService {
  static Future<Gallery?> createAudio({
    required int albumId,
    required List<int> fileIdList,
    required List<String> thumbnailUrlList,
    required String title,
    required String coverUrl,
    required int order,
  }) async {
    if (Global.user.id == null) return null;
    var audio = await GalleryApi.createGallery(
      albumId: albumId,
      fileIdList: fileIdList,
      thumbnailUrlList: thumbnailUrlList,
      title: title,
      coverUrl: coverUrl,
      order: order,
    );
    return audio;
  }

  static Future<void> deleteGallery({
    required int galleryId,
  }) async {
    await GalleryApi.deleteGallery(galleryId: galleryId);
  }

  static Future<void> updateGallery({
    required int galleryId,
    required String title,
    required String coverUrl,
    required List<int> fileIdList,
    required List<String> thumbnailUrlList,
    required int order,
  }) async {
    await GalleryApi.updateGallery(
      galleryId: galleryId,
      fileIdList: fileIdList,
      thumbnailUrlList: thumbnailUrlList,
      title: title,
      coverUrl: coverUrl,
      order: order,
    );
  }

  static Future<List<Gallery>> searchGallery({
    required int keyword,
    required String page,
    required String pageSize,
  }) async {
    var list = await GalleryApi.searchGallery(keyword: keyword, pageIndex: page, pageSize: pageSize);
    return list;
  }

  static Future<List<Gallery>> getFeedGallery({
    required String pageSize,
  }) async {
    var list = await GalleryApi.getFeedGallery(pageSize: pageSize);
    return list;
  }

  static Future<List<Gallery>> getGalleryListByAlbum({
    required String albumId,
    required int pageIndex,
    required int pageSize,
  }) async {
    var list = await GalleryApi.getGalleryListByAlbum(pageSize: pageSize, albumId: albumId, pageIndex: pageIndex);
    return list;
  }
}
