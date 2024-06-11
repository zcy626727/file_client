import 'package:file_client/common/list/common_item_list.dart';
import 'package:file_client/model/space/space.dart';
import 'package:file_client/service/team/space_service.dart';
import 'package:file_client/view/page/space/space_page.dart';
import 'package:file_client/view/widget/common_search_text_field.dart';
import 'package:flutter/material.dart';

import '../../state/screen_state.dart';
import '../component/space/space_edit_dialog.dart';
import '../component/space/space_grid_item.dart';
import '../widget/desktop_nav_button.dart';

class SpaceScreen extends StatefulWidget {
  const SpaceScreen({super.key});

  @override
  State<SpaceScreen> createState() => _SpaceScreenState();
}

class _SpaceScreenState extends State<SpaceScreen> {
  List<Space> _searchSpaceList = <Space>[];
  GlobalKey<CommonItemListState<Space>> mySpaceListKey = GlobalKey<CommonItemListState<Space>>();
  String? _searchKeyword;

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
                                        mySpaceListKey.currentState?.addItem(space);
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
                                key: mySpaceListKey,
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
                                    selectedIndex: 0,
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
                    child: Container(
                  margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: Column(
                    children: [
                      //搜索栏
                      CommonSearchTextField(
                        height: 40,
                        onSubmitted: (value) {
                          if (value.isEmpty) return;
                          _searchKeyword = value;
                          setState(() {});
                        },
                      ),
                      const SizedBox(height: 5),
                      // 搜索到的空间列表，searchSpaceList
                      Expanded(
                        child: CommonItemList<Space>(
                          key: ValueKey(_searchKeyword),
                          onLoad: (int page) async {
                            if (_searchKeyword == null) return <Space>[];
                            var list = await SpaceService.searchSpaceList(keyword: _searchKeyword!, pageIndex: page).timeout(const Duration(seconds: 2));
                            return list;
                          },
                          itemName: "",
                          itemHeight: null,
                          enableScrollbar: true,
                          isGrip: true,
                          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 240,
                            childAspectRatio: 2.5,
                            mainAxisSpacing: 5,
                            crossAxisSpacing: 5,
                          ),
                          itemBuilder: (ctx, item, itemList, onFresh) {
                            return SpaceGridItem(space: item);
                          },
                        ),
                      ),
                    ],
                  ),
                )),
              ],
            );
          },
        );
      },
    );
  }
}
