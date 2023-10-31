import 'package:file_client/api/client/share/album_api.dart';
import 'package:file_client/api/client/share/application_api.dart';
import 'package:file_client/config/global.dart';
import 'package:file_client/model/share/album.dart';
import 'package:file_client/model/share/application.dart';

class ApplicationService {
  static Future<Application?> createApplication({
    required String albumId,
    required String title,
    required int fileId,
    String? introduction,
    String? coverUrl,
    int? version,
    int? order,
  }) async {
    if (Global.user.id == null) return null;
    var application = await ApplicationApi.createApplication(
      albumId: albumId,
      fileId: fileId,
      title: title,
      introduction: introduction,
      coverUrl: coverUrl,
      version: version,
      order: order,
    );
    return application;
  }

  static Future<void> deleteApplication({
    required int applicationId,
  }) async {
    await ApplicationApi.deleteApplication(applicationId: applicationId);
  }

  static Future<void> updateApplication({
    required int applicationId,
    required String title,
    required String introduction,
    required String coverUrl,
    required int order,
  }) async {
    await ApplicationApi.updateApplication(
      applicationId: applicationId,
      title: title,
      introduction: introduction,
      coverUrl: coverUrl,
      order: order,
    );
  }

  static Future<List<Application>> searchApplication({
    required int keyword,
    required String page,
    required String pageSize,
  }) async {
    var list = await ApplicationApi.searchApplication(keyword: keyword, pageIndex: page, pageSize: pageSize);
    return list;
  }

  static Future<List<Application>> getFeedApplication({
    required String pageSize,
  }) async {
    var list = await ApplicationApi.getFeedApplication(pageSize: pageSize);
    return list;
  }

  static Future<List<Application>> getApplicationListByAlbum({
    required String albumId,
    required int pageIndex,
    required int pageSize,
  }) async {
    var list = await ApplicationApi.getApplicationListByAlbum(pageSize: pageSize, albumId: albumId, pageIndex: pageIndex);
    return list;
  }
}
