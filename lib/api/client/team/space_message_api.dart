import 'package:dio/dio.dart';
import 'package:file_client/model/user/user.dart';

import '../../../model/space/space_message.dart';
import '../team_http_config.dart';

class SpaceMessageApi {
  static Future<SpaceMessage> createJoin({
    required int spaceId,
    String? message,
  }) async {
    var r = await TeamHttpConfig.dio.post(
      "/spaceMessage/createJoin",
      data: FormData.fromMap({
        "spaceId": spaceId,
        "message": message,
      }),
      options: TeamHttpConfig.options.copyWith(
        extra: {
          "noCache": true,
          "withToken": true,
        },
      ),
    );

    return SpaceMessage.fromJson(r.data['spaceMessage']);
  }

  static Future<void> acceptJoin({
    required int msgId,
  }) async {
    await TeamHttpConfig.dio.post(
      "/spaceMessage/acceptJoin",
      data: FormData.fromMap({
        "msgId": msgId,
      }),
      options: TeamHttpConfig.options.copyWith(
        extra: {
          "noCache": true,
          "withToken": true,
        },
      ),
    );
  }

  static Future<void> refuseJoin({
    required int msgId,
  }) async {
    await TeamHttpConfig.dio.post(
      "/spaceMessage/refuseJoin",
      data: FormData.fromMap({
        "msgId": msgId,
      }),
      options: TeamHttpConfig.options.copyWith(
        extra: {
          "noCache": true,
          "withToken": true,
        },
      ),
    );
  }

  static Future<List<SpaceMessage>> getJoinMessageBySpace({
    required int spaceId,
    required int pageIndex,
    required int pageSize,
  }) async {
    var r = await TeamHttpConfig.dio.get(
      "/spaceMessage/getJoinMessageBySpace",
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
    print("object");
    return _parseSpaceMessageList(r);
  }

  static List<SpaceMessage> _parseSpaceMessageList(Response<dynamic> r) {
    List<SpaceMessage> list = [];
    Map<int?, User> userMap = <int, User>{};
    if (r.data["userList"] != null) {
      for (var json in r.data["userList"]) {
        var user = User.fromJson(json);
        userMap[user.id] = user;
      }
    }
    if (r.data["spaceMessageList"] != null) {
      for (var json in r.data["spaceMessageList"]) {
        var message = SpaceMessage.fromJson(json);
        message.user = userMap[message.userId];
        list.add(message);
      }
    }
    return list;
  }
}
