import 'package:file_client/api/client/share/subscribe_album_api.dart';
import 'package:file_client/model/share/subscribe_album.dart';

import '../../config/global.dart';

class SubscribeAlbumService {
  static Future<SubscribeAlbum> createSubscribe({
    required String albumId,
  }) async {
    if (Global.user.id == null) throw const FormatException("用户未登录");
    var subscribe = await SubscribeAlbumApi.createSubscribe(albumId: albumId);
    return subscribe;
  }

  static Future<void> deleteSubscribe({
    required String subscribeId,
  }) async {
    if (Global.user.id == null) throw const FormatException("用户未登录");
    await SubscribeAlbumApi.deleteSubscribe(subscribeId: subscribeId);
  }

  static Future<SubscribeAlbum?> getUserSubscribeAlbumInfo({
    required String albumId,
  }) async {
    if (Global.user.id == null) throw const FormatException("用户未登录");
    return await SubscribeAlbumApi.getUserSubscribeAlbumInfo(albumId: albumId);
  }
}
