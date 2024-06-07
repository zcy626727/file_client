import 'package:file_client/view/component/space/space_setting_dialog.dart';
import 'package:file_client/view/page/space/space_group_page.dart';
import 'package:file_client/view/page/space/space_member_page.dart';
import 'package:file_client/view/page/space/space_message_page.dart';
import 'package:file_client/view/page/space/space_workapace_page.dart';
import 'package:flutter/material.dart';

import '../../../config/constants.dart';
import '../../../constant/space.dart';
import '../../component/common/common_side_title.dart';
import '../../widget/desktop_nav_button.dart';

class SpacePage extends StatefulWidget {
  const SpacePage({super.key, required this.spaceId});

  final int spaceId;

  @override
  State<SpacePage> createState() => _SpacePageState();
}

class _SpacePageState extends State<SpacePage> {
  late Future _futureBuilderFuture;
  int _pageIndex = -1;

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
                        title: "空间设置",
                        iconData: Icons.settings,
                        onPress: () {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return SpaceEditDialog();
                            },
                          );
                        },
                        height: 30,
                        index: 0,
                        selectedIndex: 1,
                      ),
                      NavButton(
                        title: "成员管理",
                        iconData: Icons.person,
                        onPress: () {
                          setState(() {
                            _pageIndex = SpaceNav.member;
                          });
                        },
                        height: 30,
                        index: 0,
                        selectedIndex: 1,
                      ),
                      NavButton(
                        title: "分组管理",
                        iconData: Icons.group,
                        onPress: () {
                          setState(() {
                            _pageIndex = SpaceNav.group;
                          });
                        },
                        height: 30,
                        index: 0,
                        selectedIndex: 1,
                      ),
                      NavButton(
                        title: "消息管理",
                        iconData: Icons.add_box,
                        onPress: () {
                          setState(() {
                            _pageIndex = SpaceNav.message;
                          });
                        },
                        height: 30,
                        index: 0,
                        selectedIndex: 1,
                      ),
                      NavButton(
                        title: "文件列表",
                        iconData: Icons.folder,
                        onPress: () {
                          setState(() {
                            _pageIndex = SpaceNav.workspace;
                          });
                        },
                        height: 30,
                        index: 0,
                        selectedIndex: 1,
                      ),
                      const CommonSideTitle(value: "空间"),
                      NavButton(
                        title: "文件夹1",
                        iconData: Icons.folder,
                        onPress: () {
                          setState(() {
                            _pageIndex = SpaceNav.workspace;
                          });
                        },
                        height: 30,
                        index: 0,
                        selectedIndex: 1,
                      ),
                      const CommonSideTitle(value: "我的"),
                      NavButton(
                        title: "文件夹2",
                        iconData: Icons.folder,
                        onPress: () {
                          setState(() {
                            _pageIndex = SpaceNav.workspace;
                          });
                        },
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
                Expanded(child: _getPage())
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

  Widget _getPage() {
    switch (_pageIndex) {
      case SpaceNav.member:
        return SpaceMemberPage();
      case SpaceNav.message:
        return SpaceMessagePage();
      case SpaceNav.group:
        return SpaceGroupPage();
      case SpaceNav.workspace:
        return SpaceWorkspacePage(spaceId: widget.spaceId);
      default:
        return Container();
    }
  }
}
