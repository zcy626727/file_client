import 'package:file_client/api/client/share/topic_api.dart';
import 'package:file_client/config/global.dart';
import 'package:file_client/model/share/topic.dart';

class TopicService {
  static Future<Topic> createTopic({
    required String title,
    required String introduction,
    required String coverUrl,
    required int albumType,
  }) async {
    if (Global.user.id == null) throw const FormatException("登录信息有误");
    var topic = await TopicApi.createTopic(
      title: title,
      introduction: introduction,
      coverUrl: coverUrl,
      albumType: albumType,
    );
    return topic;
  }

  static Future<void> deleteTopic({
    required String topicId,
  }) async {
    await TopicApi.deleteTopic(topicId: topicId);
  }

  static Future<void> updateTopic({
    required String topicId,
    required String title,
    required String introduction,
    required String coverUrl,
  }) async {
    await TopicApi.updateTopic(
      topicId: topicId,
      title: title,
      introduction: introduction,
      coverUrl: coverUrl,
    );
  }

  static Future<List<Topic>> searchTopic({
    required String keyword,
    required int page,
    required int pageSize,
  }) async {
    var list = await TopicApi.searchTopic(keyword: keyword, pageIndex: page, pageSize: pageSize);
    return list;
  }

  static Future<List<Topic>> getFeedTopic({
    required int pageSize,
  }) async {
    var list = await TopicApi.getFeedTopic(pageSize: pageSize);
    return list;
  }

  static Future<List<Topic>> getUserTopicList({
    required int pageIndex,
    required int pageSize,
  }) async {
    var list = await TopicApi.getUserTopicList(pageIndex: pageIndex, pageSize: pageSize);
    return list;
  }

  static Future<List<Topic>> getSubscribeTopicList({
    required int pageIndex,
    required int pageSize,
  }) async {
    var list = await TopicApi.getSubscribeTopicList(pageIndex: pageIndex, pageSize: pageSize);
    return list;
  }
}
