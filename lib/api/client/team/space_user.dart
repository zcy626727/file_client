import 'package:file_client/model/space/space_user.dart';

import '../team_http_config.dart';

class SpaceUserApi {
  static Future<void> deleteUser({
    required int spaceUserId,
  }) async {
    await TeamHttpConfig.dio.delete(
      "/spaceUser/removeUser",
      queryParameters: {
        "spaceUserId": spaceUserId,
      },
      options: TeamHttpConfig.options.copyWith(
        extra: {
          "noCache": true,
          "withToken": true,
        },
      ),
    );
  }

  static Future<SpaceUser?> getSpaceUser({
    required int spaceId,
  }) async {
    var r = await TeamHttpConfig.dio.get(
      "/spaceUser/getSpaceUser",
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
    if (r.data['spaceUser'] == null) return null;
    return SpaceUser.fromJson(r.data['spaceUser']);
  }
}
