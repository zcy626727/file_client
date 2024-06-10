import 'package:file_client/config/net_config.dart';

import '../../api/client/team/space_message_api.dart';
import '../../model/space/space_message.dart';

class SpaceMessageService {
  static Future<SpaceMessage> createJoin({
    required int spaceId,
    String? message,
  }) async {
    var userMsg = await SpaceMessageApi.createJoin(message: message, spaceId: spaceId);
    return userMsg;
  }

  static Future<void> acceptJoin({
    required int msgId,
  }) async {
    await SpaceMessageApi.acceptJoin(msgId: msgId);
  }

  static Future<void> refuseJoin({
    required int msgId,
  }) async {
    await SpaceMessageApi.refuseJoin(msgId: msgId);
  }

  static Future<List<SpaceMessage>> getJoinMessageBySpace({
    required int spaceId,
    int pageIndex = 0,
    int pageSize = NetConfig.commonPageSize,
  }) async {
    return await SpaceMessageApi.getJoinMessageBySpace(spaceId: spaceId, pageIndex: pageIndex, pageSize: pageSize);
  }
}
