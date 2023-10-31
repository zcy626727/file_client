import 'package:dio/dio.dart';

import '../../../model/share/subscribe_topic.dart';
import '../share_http_config.dart';

class SubscribeTopicApi {
  static Future<SubscribeTopic> createSubscribe({
    required String topicId,
  }) async {
    var r = await ShareHttpConfig.dio.post(
      "/subscribeTopic/createSubscribe",
      data: FormData.fromMap({
        "albumId": topicId,
      }),
      options: ShareHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );

    //获取数据
    return SubscribeTopic.fromJson(r.data['subscribeTopic']);
  }

  static Future<void> deleteSubscribe({
    required String subscribeId,
  }) async {
    var r = await ShareHttpConfig.dio.post(
      "/subscribeTopic/deleteSubscribe",
      data: FormData.fromMap({
        "subscribeId": subscribeId,
      }),
      options: ShareHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
  }

  static Future<SubscribeTopic?> getUserSubscribeTopicInfo({
    required String topicId,
  }) async {
    var r = await ShareHttpConfig.dio.get(
      "/subscribeTopic/getUserSubscribeTopicInfo",
      queryParameters: {
        "topicId": topicId,
      },
      options: ShareHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
    //获取数据
    var json = r.data['subscribeTopic'];
    if (json == null) return null;
    return SubscribeTopic.fromJson(json);
  }
}
