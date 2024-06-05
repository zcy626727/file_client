import 'package:file_client/api/client/common/file_api.dart';

// var (getUrl, staticUrl) = await FileApi.genGetFileUrl(task.fileId!);
// task.getUrl = getUrl;
// task.staticUrl = staticUrl;
// sendPort.send([1, task.toJson()]);

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