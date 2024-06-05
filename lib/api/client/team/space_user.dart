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
}
