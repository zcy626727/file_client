import 'package:dio/dio.dart';

import '../../../model/share/gallery.dart';
import '../share_http_config.dart';

class GalleryApi {
  static Future<Gallery> createGallery({
    required int albumId,
    required List<int> fileIdList,
    required List<String> thumbnailUrlList,
    required String title,
    required String coverUrl,
    required int order,
  }) async {
    var r = await ShareHttpConfig.dio.post(
      "/gallery/createGallery",
      data: FormData.fromMap({
        "albumId": albumId,
        "fileIdList": fileIdList,
        "thumbnailUrlList": thumbnailUrlList,
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
    return Gallery.fromJson(r.data['gallery']);
  }

  static Future<void> deleteGallery({
    required int galleryId,
  }) async {
    await ShareHttpConfig.dio.post(
      "/gallery/deleteGallery",
      data: FormData.fromMap({
        "galleryId": galleryId,
      }),
      options: ShareHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
  }

  static Future<void> updateGallery({
    required int galleryId,
    required String title,
    required String coverUrl,
    required List<int> fileIdList,
    required List<String> thumbnailUrlList,
    required int order,
  }) async {
    await ShareHttpConfig.dio.post(
      "/gallery/updateGallery",
      data: FormData.fromMap({
        "galleryId": galleryId,
        "fileIdList": fileIdList,
        "thumbnailUrlList": thumbnailUrlList,
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

  static Future<List<Gallery>> searchGallery({
    required int keyword,
    required String pageIndex,
    required String pageSize,
  }) async {
    var r = await ShareHttpConfig.dio.get(
      "/gallery/searchGallery",
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
    List<Gallery> galleryList = [];
    for (var galleryJson in r.data['galleryList']) {
      galleryList.add(Gallery.fromJson(galleryJson));
    }
    return galleryList;
  }

  static Future<List<Gallery>> getFeedGallery({
    required String pageSize,
  }) async {
    var r = await ShareHttpConfig.dio.get(
      "/gallery/getFeedAudio",
      queryParameters: {
        "pageSize": pageSize,
      },
      options: ShareHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": false,
      }),
    );
    List<Gallery> galleryList = [];
    for (var galleryJson in r.data['galleryList']) {
      galleryList.add(Gallery.fromJson(galleryJson));
    }
    return galleryList;
  }

  static Future<List<Gallery>> getGalleryListByAlbum({
    required String albumId,
    required int pageIndex,
    required int pageSize,
  }) async {
    var r = await ShareHttpConfig.dio.get(
      "/gallery/getGalleryListByAlbum",
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
    List<Gallery> galleryList = [];
    for (var galleryJson in r.data['galleryList']) {
      galleryList.add(Gallery.fromJson(galleryJson));
    }
    return galleryList;
  }
}
