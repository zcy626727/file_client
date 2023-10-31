import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../component/share/share_resource_grid_item.dart';
import '../../widget/common_tab_bar.dart';

class GlobalShareContentPage extends StatefulWidget {
  const GlobalShareContentPage({Key? key}) : super(key: key);

  @override
  State<GlobalShareContentPage> createState() => _GlobalShareContentPageState();
}

class _GlobalShareContentPageState extends State<GlobalShareContentPage> {
  List<String> tabBarList = <String>[
    "视频",
    "音频",
    "图片",
    "文本",
    "软件",
  ];

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var width = MediaQuery.of(context).size.width;

    return Navigator(
      onGenerateRoute: (val) {
        return PageRouteBuilder(
          pageBuilder: (BuildContext nContext, Animation<double> animation, Animation<double> secondaryAnimation) {
            return DefaultTabController(
              length: tabBarList.length,
              child: Column(
                children: [
                  CommonTabBar(
                    titleTextList: tabBarList,
                  ),
                  Expanded(
                    child: TabBarView(
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.only(
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
                            Expanded(
                              child: GridView.builder(
                                padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                                // gridDelegate:
                                //     const SliverGridDelegateWithMaxCrossAxisExtent(
                                //   maxCrossAxisExtent: 230,
                                //   crossAxisSpacing: 10,
                                //   mainAxisSpacing: 10,
                                // ),
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 5, //横轴三个子widget
                                ),
                                itemCount: 10,
                                itemBuilder: (context, index) {
                                  //如果显示到最后一个并且Icon总数小于200时继续获取数据
                                  return ShareResourceGridItem();
                                },
                              ),
                            )
                          ],
                        ),
                        Text("精品"),
                        Text("话题"),
                        Text("杂谈"),
                        Text("杂谈"),
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }
}
