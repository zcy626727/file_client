import 'package:dio/dio.dart';

import '../../../api/client/file_http_config.dart';

class FileApi {
  //获取putUrl，小文件上传
  static Future<(String, int)> genPutFileUrl(
    String md5,
    bool private,
    List<int> magicNumber,
  ) async {
    var r = await FileHttpConfig.dio.get(
      "/file/genPutFileUrl",
      queryParameters: {
        "md5": md5,
        "isPrivate": private,
        "magicNumber": magicNumber,
      },
      options: FileHttpConfig.options.copyWith(
        extra: {
          "noCache": true,
          "withToken": true,
        },
      ),
    );

    String putFileUrl = r.data["putFileUrl"];
    int fileId = r.data["fileId"];
    //获取数据
    return (putFileUrl, fileId);
  }

  //获取getUrl，文件下载
  static Future<void> completePutFile(int fileId) async {
    await FileHttpConfig.dio.post(
      "/file/completePutFile",
      data: FormData.fromMap({
        "fileId": fileId,
      }),
      options: FileHttpConfig.options.copyWith(
        extra: {
          "noCache": true,
          "withToken": true,
        },
      ),
    );
  }

  //获取getUrl，文件下载
  static Future<(String, String)> genGetFileUrl(int fileId) async {
    var r = await FileHttpConfig.dio.get(
      "/file/genGetFileUrl",
      queryParameters: {
        "fileId": fileId,
      },
      options: FileHttpConfig.options.copyWith(
        extra: {
          "noCache": true,
          "withToken": true,
        },
      ),
    );

    String getFileUrl = r.data["getFileUrl"] ?? "";
    String staticUrl = r.data["staticUrl"] ?? "";
    //获取数据
    return (getFileUrl, staticUrl);
  }
}
