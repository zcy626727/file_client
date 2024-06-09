import 'package:file_client/common/list/common_item_list.dart';
import 'package:file_client/model/space/space.dart';
import 'package:file_client/service/team/space_service.dart';
import 'package:file_client/view/page/space/space_page.dart';
import 'package:file_client/view/widget/common_search_text_field.dart';
import 'package:flutter/material.dart';

import '../../state/screen_state.dart';
import '../component/space/space_edit_dialog.dart';
import '../widget/desktop_nav_button.dart';

class SpaceScreen extends StatefulWidget {
  const SpaceScreen({super.key});

  @override
  State<SpaceScreen> createState() => _SpaceScreenState();
}

class _SpaceScreenState extends State<SpaceScreen> {
  List<Space> _searchSpaceList = <Space>[];
  GlobalKey<CommonItemListState<Space>> listKey = GlobalKey<CommonItemListState<Space>>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    return Navigator(
      onGenerateRoute: (val) {
        return PageRouteBuilder(
          pageBuilder: (BuildContext nContext, Animation<double> animation, Animation<double> secondaryAnimation) {
            return Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  width: 180,
                  child: Row(
                    children: [
                      VerticalDivider(color: Colors.grey.withAlpha(100), width: 1),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 成员
                            NavButton(
                              title: "创建空间",
                              iconData: Icons.add_box_outlined,
                              onPress: () {
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return SpaceEditDialog(
                                      onCreateSpace: (space) {
                                        listKey.currentState?.addItem(space);
                                        setState(() {});
                                      },
                                    );
                                  },
                                );
                              },
                              height: 30,
                              index: 0,
                              selectedIndex: 1,
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 10.0, top: 5.0, bottom: 5.0),
                              child: const Text("我的空间", style: TextStyle(color: Colors.grey, fontSize: 12)),
                            ),
                            Expanded(
                              child: CommonItemList<Space>(
                                onLoad: (int page) async {
                                  var list = await SpaceService.getUserSpaceList(pageIndex: page).timeout(const Duration(seconds: 2));
                                  return list;
                                },
                                key: listKey,
                                itemName: "空间",
                                itemHeight: null,
                                enableScrollbar: true,
                                itemBuilder: (ctx, item, itemList, onFresh) {
                                  return NavButton(
                                    title: item.name ?? "未知",
                                    iconData: Icons.square,
                                    onPress: () {
                                      // 点击后弹出空间详情页面
                                      Navigator.push(
                                        nContext,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return SpacePage(
                                              space: item,
                                              onUpdateSpace: (space) {
                                                onFresh();
                                              },
                                            );
                                          },
                                        ),
                                      );
                                    },
                                    index: SecondNav.workspace,
                                    selectedIndex: 1,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      VerticalDivider(color: Colors.grey.withAlpha(100), width: 1),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      //搜索栏
                      CommonSearchTextField(height: 65),
                      // 搜索到的空间列表，searchSpaceList
                      // Expanded(
                      //   child: Container(
                      //     padding: const EdgeInsets.only(left: 15),
                      //     child: GridView.builder(
                      //       padding: const EdgeInsets.only(right: 15),
                      //       controller: ScrollController(),
                      //       gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      //         maxCrossAxisExtent: 240,
                      //         childAspectRatio: 2.5,
                      //         mainAxisSpacing: 5,
                      //         crossAxisSpacing: 5,
                      //       ),
                      //       itemCount: 11,
                      //       itemBuilder: (context, index) {
                      //         return SpaceGridItem(space: ,);
                      //       },
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
