import 'package:file_client/view/page/global/video_share_edit_page.dart';
import 'package:flutter/material.dart';

import '../../widget/common_tab_bar.dart';

class GlobalShareEditPage extends StatefulWidget {
  const GlobalShareEditPage({Key? key}) : super(key: key);

  @override
  State<GlobalShareEditPage> createState() => _GlobalShareEditPageState();
}

class _GlobalShareEditPageState extends State<GlobalShareEditPage> {
  List<String> tabBarList = <String>[
    "视频",
    "音频",
    "图片",
    "文档",
    "软件",
  ];

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

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
                        VideoShareEditPage(),
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
