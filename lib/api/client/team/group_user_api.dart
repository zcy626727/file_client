import 'package:dio/dio.dart';
import 'package:file_client/model/space/group_user.dart';

import '../team_http_config.dart';

class GroupUserApi {
  static Future<GroupUser> addGroup({
    required int groupId,
    required int targetUserId,
  }) async {
    var r = await TeamHttpConfig.dio.post(
      "/groupUser/addGroup",
      data: FormData.fromMap({
        "targetUserId": targetUserId,
        "groupId": groupId,
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
    required int groupId,
    required int targetUserId,
  }) async {
    await TeamHttpConfig.dio.delete(
      "/groupUser/removeGroup",
      queryParameters: {
        "groupId": groupId,
        "targetUserId": targetUserId,
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
