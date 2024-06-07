import 'package:file_client/api/client/share/subscribe_topic_api.dart';

import '../../config/global.dart';
import '../../model/share/subscribe_topic.dart';

class SubscribeTopicService {
  static Future<SubscribeTopic> createSubscribe({
    required String topicId,
  }) async {
    if (Global.user.id == null) throw const FormatException("用户未登录");
    var subscribe = await SubscribeTopicApi.createSubscribe(topicId: topicId);
    return subscribe;
  }

  static Future<void> deleteSubscribe({
    required String subscribeId,
  }) async {
    if (Global.user.id == null) throw const FormatException("用户未登录");
    await SubscribeTopicApi.deleteSubscribe(subscribeId: subscribeId);
  }

  static Future<SubscribeTopic?> getUserSubscribeTopicInfo({
    required String topicId,
  }) async {
    if (Global.user.id == null) throw const FormatException("用户未登录");
    return await SubscribeTopicApi.getUserSubscribeTopicInfo(topicId: topicId);
  }
}
