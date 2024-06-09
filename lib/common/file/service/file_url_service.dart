import '../api/file_api.dart';

class FileUrlService {
  static Future<(String, String)> genGetFileUrl(int fileId) async {
    var t = await FileApi.genGetFileUrl(fileId);
    return t;
  }

  static Future<(String, int)> genPutFileUrl(
      String md5,
      bool isPrivate,
      List<int> magicNumber,
      ) async {
    return await FileApi.genPutFileUrl(md5, isPrivate, magicNumber);
  }
}