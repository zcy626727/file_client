import 'package:flutter/material.dart';

import '../../../common/list/common_item_list.dart';
import '../../../model/share/topic.dart';
import '../../../service/share/topic_service.dart';
import '../../component/topic/topic_item.dart';

class SubscribeTopicPage extends StatefulWidget {
  const SubscribeTopicPage({super.key});

  @override
  State<SubscribeTopicPage> createState() => _SubscribeTopicPageState();
}

class _SubscribeTopicPageState extends State<SubscribeTopicPage> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var colorScheme = Theme.of(context).colorScheme;
    return Navigator(
      onGenerateRoute: (val) {
        return PageRouteBuilder(
          pageBuilder: (BuildContext nContext, Animation<double> animation, Animation<double> secondaryAnimation) {
            return Container(
              color: Theme.of(context).colorScheme.background,
              child: CommonItemList<Topic>(
                onLoad: (int page) async {
                  var list = await TopicService.getSubscribeTopicList(pageIndex: page, pageSize: 20);
                  return list;
                },
                itemName: "主题",
                itemHeight: null,
                isGrip: true,
                enableScrollbar: true,
                itemBuilder: (ctx, topic, topicList, onFresh) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 2, left: 5, right: 5),
                    child: TopicItem(
                      topic: topic,
                      onDeleteTopic: (t) {
                        setState(() {
                          topicList?.remove(t);
                        });
                      },
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
