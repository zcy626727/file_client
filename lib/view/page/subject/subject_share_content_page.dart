import 'package:file_client/view/component/topic/topic_item.dart';
import 'package:file_client/view/widget/common_media_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../widget/common_tab_bar.dart';

class SubjectShareContentPage extends StatefulWidget {
  const SubjectShareContentPage({Key? key}) : super(key: key);

  @override
  State<SubjectShareContentPage> createState() =>
      _SubjectShareContentPageState();
}

class _SubjectShareContentPageState extends State<SubjectShareContentPage> {
  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var width = MediaQuery.of(context).size.width;

    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const CommonTabBar(
            titleTextList: ["主题广场", "我的订阅"],
          ),
          Expanded(
            child: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              children: [
                Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                        left: 5.0,
                        right: 5.0,
                        top: 5.0,
                      ),
                      child: const CupertinoSearchTextField(),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                        left: 5.0,
                        right: 5.0,
                        top: 5.0,
                      ),
                      height: 30,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          ActionChip(
                            label: const Text('学习'),
                            onPressed: () {},
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: ActionChip(
                              label: const Text('游戏'),
                              onPressed: () {},
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: ActionChip(
                              label: const Text('18禁'),
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Expanded(
                    //   child: GridView.builder(
                    //     padding: const EdgeInsets.symmetric(
                    //         vertical: 5.0, horizontal: 5.0),
                    //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    //       crossAxisCount: 4, //横轴三个子widget
                    //       childAspectRatio: 1.5,
                    //     ),
                    //     itemCount: 20,
                    //     itemBuilder: (context, index) {
                    //       //如果显示到最后一个并且Icon总数小于200时继续获取数据
                    //       return TopicItem();
                    //     },
                    //   ),
                    // )
                  ],
                ),
                Column(
                  children: [
                    // Expanded(
                    //   child: GridView.builder(
                    //     padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                    //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    //       crossAxisCount: 4, //横轴三个子widget
                    //       childAspectRatio: 1.5,
                    //     ),
                    //     itemCount: 20,
                    //     itemBuilder: (context, index) {
                    //       //如果显示到最后一个并且Icon总数小于200时继续获取数据
                    //       return TopicItem();
                    //     },
                    //   ),
                    // )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
