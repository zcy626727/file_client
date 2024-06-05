import 'package:dio/dio.dart';
import 'package:file_client/model/space/group_user.dart';

import '../team_http_config.dart';

class GroupUserApi {
  static Future<GroupUser> addGroup({
    required int spaceId,
    required int targetUserId,
  }) async {
    var r = await TeamHttpConfig.dio.post(
      "/groupUser/addGroup",
      data: FormData.fromMap({
        "targetUserId": targetUserId,
        "spaceId": spaceId,
      }),
      options: TeamHttpConfig.options.copyWith(
        extra: {
          "noCache": true,
          "withToken": true,
        },
      ),
    );
    return GroupUser.fromJson(r.data['groupUser']);
  }

  static Future<void> removeGroup({
    required int groupUserId,
  }) async {
    await TeamHttpConfig.dio.delete(
      "/groupUser/removeGroup",
      queryParameters: {
        "groupUserId": groupUserId,
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
