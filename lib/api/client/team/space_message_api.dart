import 'package:dio/dio.dart';

import '../../../model/space/space_message.dart';
import '../team_http_config.dart';

class SpaceMessageApi {
  static Future<SpaceMessage> createJoin({
    required int spaceId,
    required String message,
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
    var r = await TeamHttpConfig.dio.post(
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
    var r = await TeamHttpConfig.dio.post(
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
}
