import 'package:dio/dio.dart';
import 'package:file_client/model/share/album.dart';

import '../../../model/share/topic.dart';
import '../share_http_config.dart';

class TopicApi {
  static Future<Topic> createTopic({
    required String title,
    required String introduction,
    required String coverUrl,
    required int albumType,
  }) async {
    var r = await ShareHttpConfig.dio.post(
      "/topic/createTopic",
      data: FormData.fromMap({
        "title": title,
        "introduction": introduction,
        "coverUrl": coverUrl,
        "albumType": albumType,
      }),
      options: ShareHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );

    //获取数据
    return Topic.fromJson(r.data['topic']);
  }

  static Future<void> deleteTopic({
    required String topicId,
  }) async {
    var r = await ShareHttpConfig.dio.post(
      "/topic/deleteTopic",
      data: FormData.fromMap({
        "topicId": topicId,
      }),
      options: ShareHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
  }

  static Future<void> updateTopic({
    required String topicId,
    required String title,
    required String introduction,
    required String coverUrl,
  }) async {
    var r = await ShareHttpConfig.dio.post(
      "/topic/updateTopic",
      data: FormData.fromMap({
        "topicId": topicId,
        "title": title,
        "introduction": introduction,
        "coverUrl": coverUrl,
      }),
      options: ShareHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
  }

  static Future<List<Topic>> searchTopic({
    required String keyword,
    required int pageIndex,
    required int pageSize,
  }) async {
    var r = await ShareHttpConfig.dio.get(
      "/topic/searchTopic",
      queryParameters: {
        "keyword": keyword,
        "pageIndex": pageIndex,
        "pageSize": pageSize,
      },
      options: ShareHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": false,
      }),
    );
    List<Topic> topicList = [];
    for (var topicJson in r.data['topicList']) {
      topicList.add(Topic.fromJson(topicJson));
    }
    return topicList;
  }

  static Future<List<Topic>> getFeedTopic({
    required int pageSize,
  }) async {
    var r = await ShareHttpConfig.dio.get(
      "/topic/getFeedTopic",
      queryParameters: {
        "pageSize": pageSize,
      },
      options: ShareHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": false,
      }),
    );
    List<Topic> topicList = [];
    for (var topicJson in r.data['topicList']) {
      topicList.add(Topic.fromJson(topicJson));
    }
    return topicList;
  }

  static Future<List<Topic>> getSubscribeTopicList({
    required int pageIndex,
    required int pageSize,
  }) async {
    var r = await ShareHttpConfig.dio.get(
      "/topic/getSubscribeTopicList",
      queryParameters: {
        "pageIndex": pageIndex,
        "pageSize": pageSize,
      },
      options: ShareHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
    List<Topic> topicList = [];
    for (var json in r.data['topicList']) {
      topicList.add(Topic.fromJson(json));
    }
    return topicList;
  }

  static Future<List<Topic>> getUserTopicList({
    required int pageIndex,
    required int pageSize,
  }) async {
    var r = await ShareHttpConfig.dio.get(
      "/topic/getUserTopicList",
      queryParameters: {
        "pageIndex": pageIndex,
        "pageSize": pageSize,
      },
      options: ShareHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
    List<Topic> topicList = [];
    for (var json in r.data['topicList']) {
      topicList.add(Topic.fromJson(json));
    }
    return topicList;
  }
}
