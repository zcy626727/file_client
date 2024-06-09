import 'package:dio/dio.dart';
import 'package:file_client/model/space/space.dart';

import '../team_http_config.dart';

class SpaceApi {
  static Future<Space> createSpace({
    required String name,
    String? avatarUrl,
    String? description,
  }) async {
    var r = await TeamHttpConfig.dio.post(
      "/space/createSpace",
      data: FormData.fromMap({
        "name": name,
        "avatarUrl": avatarUrl,
        "description": description,
      }),
      options: TeamHttpConfig.options.copyWith(
        extra: {
          "noCache": true,
          "withToken": true,
        },
      ),
    );
    return Space.fromJson(r.data['space']);
  }

  static Future<void> deleteSpace({
    required int spaceId,
  }) async {
    await TeamHttpConfig.dio.delete(
      "/space/deleteSpace",
      queryParameters: {
        "spaceId": spaceId,
      },
      options: TeamHttpConfig.options.copyWith(
        extra: {
          "noCache": true,
          "withToken": true,
        },
      ),
    );
  }

  static Future<void> updateSpace({
    required int spaceId,
    String? newName,
    String? newAvatarUrl,
  }) async {
    await TeamHttpConfig.dio.put(
      "/space/deleteSpace",
      data: FormData.fromMap({
        "spaceId": spaceId,
        "newName": newName,
        "newAvatarUrl": newAvatarUrl,
      }),
      options: TeamHttpConfig.options.copyWith(
        extra: {
          "noCache": true,
          "withToken": true,
        },
      ),
    );
  }

  static Future<List<Space>> getUserSpaceList({
    required int pageIndex,
    required int pageSize,
  }) async {
    var r = await TeamHttpConfig.dio.get(
      "/space/getUserSpaceList",
      queryParameters: {
        "pageIndex": pageIndex,
        "pageSize": pageSize,
      },
      options: TeamHttpConfig.options.copyWith(
        extra: {
          "noCache": true,
          "withToken": true,
        },
      ),
    );
    return _parseSpaceList(r);
  }

  static List<Space> _parseSpaceList(Response<dynamic> r) {
    List<Space> list = [];
    if (r.data["spaceList"] != null) {
      for (var map in r.data["spaceList"]) {
        list.add(Space.fromJson(map));
      }
    }
    return list;
  }
}
