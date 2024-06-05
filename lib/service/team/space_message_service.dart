import '../../api/client/team/space_message_api.dart';
import '../../model/space/space_message.dart';

class SpaceMessageService {
  static Future<SpaceMessage> createJoin({
    required int spaceId,
    required String message,
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
}
