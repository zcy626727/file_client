import 'package:dio/dio.dart';
import 'package:file_client/model/space/space.dart';

import '../team_http_config.dart';

class SpaceApi {
  static Future<Space> createSpace({
    String? name,
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
}
