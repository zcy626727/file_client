import 'package:flutter/material.dart';

import '../../../config/constants.dart';
import '../../widget/desktop_nav_button.dart';

class SpacePage extends StatefulWidget {
  const SpacePage({super.key});

  @override
  State<SpacePage> createState() => _SpacePageState();
}

class _SpacePageState extends State<SpacePage> {
  late Future _futureBuilderFuture;

  @override
  void initState() {
    super.initState();
    _futureBuilderFuture = getData();
  }

  Future getData() async {
    return Future.wait([]);
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    return FutureBuilder(
      future: _futureBuilderFuture,
      builder: (BuildContext context, AsyncSnapshot snapShot) {
        if (snapShot.connectionState == ConnectionState.done) {
          return Scaffold(
            backgroundColor: colorScheme.surface,
            body: Row(
              children: [
                VerticalDivider(color: Colors.grey.withAlpha(100), width: 1),

                //左侧栏
                SizedBox(
                  width: 180,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 返回
                      Container(
                        height: 45,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: colorScheme.primaryContainer),
                        margin: const EdgeInsets.only(left: 3, top: 3, right: 3, bottom: 3),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            //空间介绍
                            Row(
                              children: [
                                Container(
                                  color: colorScheme.onPrimaryContainer,
                                  margin: EdgeInsets.only(left: 5, right: 5),
                                  child: Image(
                                    height: 20,
                                    width: 20,
                                    fit: BoxFit.cover,
                                    image: NetworkImage(errImageUrl),
                                  ),
                                ),
                                Text(
                                  "空间名",
                                  style: TextStyle(color: colorScheme.onPrimaryContainer),
                                ),
                              ],
                            ),
                            //操作
                            Container(
                              width: 20,
                              height: 20,
                              margin: const EdgeInsets.only(right: 5, left: 5),
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(
                                  Icons.exit_to_app,
                                  size: 20,
                                ),
                                color: colorScheme.onBackground,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // 成员
                      NavButton(
                        title: "设置",
                        iconData: Icons.settings,
                        onPress: () {},
                        height: 30,
                        index: 0,
                        selectedIndex: 1,
                      ),
                      NavButton(
                        title: "成员",
                        iconData: Icons.person,
                        onPress: () {},
                        height: 30,
                        index: 0,
                        selectedIndex: 1,
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 10.0, top: 8.0, bottom: 2.0),
                        child: const Text("空间", style: TextStyle(color: Colors.grey, fontSize: 12)),
                      ),
                      NavButton(
                        title: "文件夹1",
                        iconData: Icons.folder,
                        onPress: () {},
                        height: 30,
                        index: 0,
                        selectedIndex: 1,
                      ),
                      NavButton(
                        title: "文件夹2",
                        iconData: Icons.folder,
                        onPress: () {},
                        height: 30,
                        index: 0,
                        selectedIndex: 1,
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 10.0, top: 8.0, bottom: 2.0),
                        child: const Text("我的", style: TextStyle(color: Colors.grey, fontSize: 12)),
                      ),
                      NavButton(
                        title: "文件夹2",
                        iconData: Icons.folder,
                        onPress: () {},
                        height: 30,
                        index: 0,
                        selectedIndex: 1,
                      ),
                      // 收藏文件夹
                    ],
                  ),
                ),
                VerticalDivider(color: Colors.grey.withAlpha(100), width: 1),

                //文件
                Expanded(child: Container())
              ],
            ),
          );
        } else {
          // 请求未结束，显示loading
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
