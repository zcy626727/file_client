import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';

class FileUtil {
  static Future<String?> getFileChecksum(File file) async {
    if (!file.existsSync()) return null;
    try {
      final stream = file.openRead();
      final hash = await md5.bind(stream).first;

      return hash.toString();
    } catch (exception) {
      return null;
    }
  }

  static Future<String> getValidFileName(String fileName, String folderPath) async {
    if (!folderPath.endsWith('/')) {
      folderPath = "$folderPath/";
    }
    var file = File('$folderPath$fileName');
    if (!await file.exists()) {
      return fileName;
    }
    int count = 1;
    final extensionIndex = fileName.lastIndexOf('.');
    final name = extensionIndex == -1 ? fileName : fileName.substring(0, extensionIndex);
    final extensionName = extensionIndex == -1 ? '' : fileName.substring(extensionIndex);
    while (await file.exists()) {
      fileName = '$name($count)$extensionName';
      file = File('$folderPath$fileName');
      count++;
    }

    return fileName;
  }

  //文件服务器
  //文件上传
  static Future<bool> uploadFile(String urlPath, List<int> data, {ProgressCallback? onUpload}) async {
    var _ = await Dio().put(
      urlPath,
      data: Stream.fromIterable(data.map((e) => [e])),
      onSendProgress: onUpload,
      options: Options(
        headers: {
          Headers.contentLengthHeader: data.length,
          Headers.contentTypeHeader: "multipart/form-data" //后加的，如果上传文件不一致可以考虑删除试试
        },
      ),
    );
    return true;
  }

  //文件下载
  static Future<void> downloadFile(String urlPath, String savePath, {Function(int)? callback}) async {
    Dio dio = Dio();
    File file = File(savePath);

    // 如果文件已存在，则获取文件长度，并设置Range请求头以支持断点续传
    bool hasFile = await file.exists();
    int receivedBytes = hasFile ? await file.length() : 0;
    Map<String, dynamic>? headers = hasFile ? {'Range': 'bytes=$receivedBytes-'} : null;

    // 发送HTTP GET请求以获取文件数据
    Response response = await dio.get(
      urlPath,
      options: Options(headers: headers, responseType: ResponseType.stream),
    );

    // 打开文件并将新的数据追加到文件中
    IOSink sink = file.openWrite(mode: FileMode.append);
    Stream<List<int>> stream = response.data.stream;
    await for (List<int> data in stream) {
      receivedBytes += data.length;
      sink.add(data);
      if (callback != null) {
        callback(receivedBytes);
      }
    }

    // 关闭文件流
    await sink.flush();
    await sink.close();
  }

  static String getUploadPercentage(int? uploaded, int? total) {
    if (total == null || uploaded == null) return "00.00%";
    if (uploaded >= total) return "100.00%";
    return '${((uploaded / total) * 100).toStringAsFixed(2)}%';
  }
}
