import '../../../domain/resource.dart';
import '../../../model/file/user_file.dart';
import '../../../model/file/user_folder.dart';
import '../file_http_config.dart';

class ResourceApi {
  static Future<List<Resource>> getFileAndFolderList({
    required int parentId,
    required List<int> statusList,
    required int fileType,
  }) async {
    var r = await FileHttpConfig.dio.get(
      "/resource/getFileAndFolderList",
      queryParameters: {
        "parentId": parentId,
        "statusList": statusList,
        "fileType": fileType,
      },
      options: FileHttpConfig.options.copyWith(
        extra: {
          "noCache": false,
          "withToken": true,
        },
      ),
    );
    var resourceList = <Resource>[];
    for (var map in r.data["fileList"]) {
      resourceList.add(UserFile.fromJson(map));
    }
    for (var json in r.data["folderList"]) {
      resourceList.add(UserFolder.fromJson(json));
    }
    return resourceList;
  }
}
