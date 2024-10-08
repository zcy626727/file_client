import 'package:file_client/model/space/space.dart';
import 'package:file_client/view/component/space/space_edit_dialog.dart';
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
  const SpacePage({super.key, required this.space, this.onUpdateSpace});

  final Space space;
  final Function(Space)? onUpdateSpace;

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
                        height: 50,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: colorScheme.primaryContainer),
                        margin: const EdgeInsets.only(left: 3, top: 3, right: 3, bottom: 3),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            //空间介绍
                            Expanded(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(left: 5, right: 5),
                                    child: CircleAvatar(
                                      radius: 20,
                                      foregroundImage: NetworkImage(
                                        widget.space.avatarUrl ?? errImageUrl,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      maxLines: 1,
                                      softWrap: false,
                                      widget.space.name ?? "解析失败",
                                      style: TextStyle(
                                        color: colorScheme.onPrimaryContainer,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
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
                      const CommonSideTitle(value: "空间管理"),
                      // 成员
                      NavButton(
                        title: "空间设置",
                        iconData: Icons.settings,
                        onPress: () {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return SpaceEditDialog(
                                space: widget.space,
                                onUpdateSpace: (space) {
                                  setState(() {});
                                  if (widget.onUpdateSpace != null) widget.onUpdateSpace!(space);
                                },
                              );
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
                        index: SpaceNav.member,
                        selectedIndex: _pageIndex,
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
                        index: SpaceNav.group,
                        selectedIndex: _pageIndex,
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
                        index: SpaceNav.message,
                        selectedIndex: _pageIndex,
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
                        index: SpaceNav.workspace,
                        selectedIndex: _pageIndex,
                      ),
                      // 收藏文件夹
                      const CommonSideTitle(value: "置顶目录"),
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
        return SpaceMemberPage(space: widget.space);
      case SpaceNav.message:
        return SpaceMessagePage(space: widget.space);
      case SpaceNav.group:
        return SpaceGroupPage(space: widget.space);
      case SpaceNav.workspace:
        return SpaceWorkspacePage(space: widget.space);
      default:
        return Container();
    }
  }
}
