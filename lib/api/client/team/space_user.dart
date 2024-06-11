import 'package:dio/dio.dart';
import 'package:file_client/model/space/space_user.dart';

import '../../../model/user/user.dart';
import '../team_http_config.dart';

class SpaceUserApi {
  static Future<void> removeUser({
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

  static Future<List<SpaceUser>> getSpaceUserList({
    required int spaceId,
    required int pageIndex,
    required int pageSize,
  }) async {
    var r = await TeamHttpConfig.dio.get(
      "/spaceUser/getSpaceUserList",
      queryParameters: {
        "spaceId": spaceId,
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
    return _parseSpaceUserList(r);
  }

  static List<SpaceUser> _parseSpaceUserList(Response<dynamic> r) {
    List<SpaceUser> list = [];
    Map<int?, User> userMap = <int, User>{};
    if (r.data["userList"] != null) {
      for (var json in r.data["userList"]) {
        var user = User.fromJson(json);
        userMap[user.id] = user;
      }
    }
    if (r.data["spaceUserList"] != null) {
      for (var json in r.data["spaceUserList"]) {
        var spaceUser = SpaceUser.fromJson(json);
        spaceUser.user = userMap[spaceUser.userId];
        list.add(spaceUser);
      }
    }
    return list;
  }
}
