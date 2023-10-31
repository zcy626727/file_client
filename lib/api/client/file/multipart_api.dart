import 'package:dio/dio.dart';

import '../../../domain/multipart_info.dart';
import '../file_http_config.dart';

class MultipartApi {
  //初始化上传任务
  static Future<MultipartInfo> initMultipartUpload(
    String md5,
    int fileSize,
    List<int> magicNumber,
  ) async {
    var r = await FileHttpConfig.dio.post(
      "/multipart/initMultipartUpload",
      data: FormData.fromMap({
        "md5": md5,
        "fileSize": fileSize,
        "isPrivate": true,
        "magicNumber": magicNumber,
      }),
      options: FileHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );

    //获取数据
    MultipartInfo multipartInfo = MultipartInfo.fromJson(r.data["multipartInfo"]);
    return multipartInfo;
  }

  //获取上传url
  static Future<(MultipartInfo, List<String>)> getUploadUrl(int fileId, int urlCount, int uploadedPartCount) async {
    var r = await FileHttpConfig.dio.get(
      "/multipart/getUploadUrl",
      queryParameters: {
        "fileId": fileId,
        "urlCount": urlCount,
        "uploadedPartNum": uploadedPartCount,
      },
      options: FileHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );

    //获取数据
    MultipartInfo multipartInfo = MultipartInfo.fromJson(r.data["multipartInfo"]);
    var list = r.data["urlList"];
    List<String> urlList = [];
    if (r.data["urlList"] != null) {
      for (var u in list) {
        urlList.add(u.toString());
      }
    }
    return (multipartInfo, urlList);
  }

  //完成上传
  static Future<void> completeMultipartUpload(int fileId) async {
    await FileHttpConfig.dio.post(
      "/multipart/completeMultipartUpload",
      data: FormData.fromMap({
        "fileId": fileId,
      }),
      options: FileHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
  }

  //中断上传
  static Future<String> abortMultipartUpload(int userFileId) async {
    var r = await FileHttpConfig.dio.post(
      "/multipart/abortMultipartUpload",
      data: FormData.fromMap({
        "userFileId": userFileId,
      }),
      options: FileHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );

    //获取数据
    return r.data["message"] as String;
  }
}
