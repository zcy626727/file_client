import 'package:file_client/model/share/topic.dart';
import 'package:file_client/view/page/topic/topic_page.dart';
import 'package:flutter/material.dart';

class TopicItem extends StatelessWidget {
  const TopicItem({Key? key, required this.topic, required this.onDeleteTopic}) : super(key: key);

  final Topic topic;
  final Function(Topic) onDeleteTopic;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      hoverColor: colorScheme.primaryContainer,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return TopicPage(
                topic: topic,
                onDeleteTopic: onDeleteTopic,
              );
            },
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 10),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //封面和头像
            Expanded(
              flex: 2,
              child: Container(
                margin: const EdgeInsets.only(top: 10),
                child: CircleAvatar(
                  radius: 26,
                  backgroundImage: NetworkImage(topic.coverUrl!),
                ),
              ),
            ),
            //主题信息
            Expanded(
              flex: 3,
              child: Container(
                margin: const EdgeInsets.only(top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      topic.title ?? "未知名称",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: colorScheme.onSurface),
                    ),
                    Text(
                      topic.introduction ?? "介绍为空",
                      style: TextStyle(fontSize: 16, color: colorScheme.onSurface.withAlpha(100)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
