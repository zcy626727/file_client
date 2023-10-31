import 'package:file_client/model/share/topic.dart';
import 'package:file_client/view/page/topic/topic_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../page/subject/subject_datail_page.dart';

class TopicItem extends StatelessWidget {
  const TopicItem({Key? key, required this.topic, required this.onDeleteTopic}) : super(key: key);

  final Topic topic;
  final Function(Topic) onDeleteTopic;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return Material(
      color: colorScheme.surface,
      child: InkWell(
        hoverColor: Colors.grey.withAlpha(50),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return TopicPage(topic: topic, onDeleteTopic: onDeleteTopic,);
              },
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //封面和头像
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 30),
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        image: DecorationImage(image: NetworkImage(topic.coverUrl!), fit: BoxFit.cover),
                      ),
                    ),
                    Positioned(
                      left: 30,
                      bottom: 10,
                      child: SizedBox(
                        width: 80,
                        child: AspectRatio(
                          aspectRatio: 3 / 4,
                          child: Image(
                            image: NetworkImage(topic.coverUrl!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              //主题信息
              Container(
                margin: const EdgeInsets.only(left: 30),
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
              )
            ],
          ),
        ),
      ),
    );
  }
}

