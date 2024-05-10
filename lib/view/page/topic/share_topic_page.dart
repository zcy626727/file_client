import 'package:file_client/model/share/topic.dart';
import 'package:file_client/view/component/topic/topic_item.dart';
import 'package:flutter/material.dart';

import '../../../service/share/topic_service.dart';
import '../../component/topic/topic_edit_dialog.dart';
import '../../widget/common_action_one_button.dart';
import '../../widget/common_item_list.dart';

class ShareTopicPage extends StatefulWidget {
  const ShareTopicPage({super.key});

  @override
  State<ShareTopicPage> createState() => _ShareTopicPageState();
}

class _ShareTopicPageState extends State<ShareTopicPage> {
  GlobalKey<CommonItemListState<Topic>> listKey = GlobalKey<CommonItemListState<Topic>>();

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (val) {
        return PageRouteBuilder(
          pageBuilder: (BuildContext nContext, Animation<double> animation, Animation<double> secondaryAnimation) {
            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0,bottom: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 30,
                        width: 120,
                        child: CommonActionOneButton(
                          title: "新建主题",
                          onTap: () async {
                            await createTopic();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Theme.of(context).colorScheme.background,
                    child: CommonItemList<Topic>(
                      key: listKey,
                      onLoad: (int page) async {
                        var list = await TopicService.getUserTopicList(pageIndex: page, pageSize: 20);
                        return list;
                      },
                      itemName: "主题",
                      itemHeight: null,
                      isGrip: true,
                      enableScrollbar: true,
                      itemBuilder: (ctx, topic, topicList, onFresh) {
                        return Container(
                          margin: const EdgeInsets.only(top: 2,bottom: 2,right: 5),
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
                  )
                )
              ],
            );
          },
        );
      },
    );
  }

  Future<void> createTopic() async {
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return TopicEditDialog(
          onCreate: (String title, String introduction, String? coverUrl, int albumType) async {
            var topic = await TopicService.createTopic(
              title: title,
              introduction: introduction,
              coverUrl: coverUrl ?? "",
              albumType: albumType,
            );
            listKey.currentState?.addItem(topic);
            listKey.currentState?.setState(() {});
            if (mounted) Navigator.of(context).pop(topic);
          },
        );
      },
    );
  }
}
