import 'package:file_client/model/space/space.dart';
import 'package:file_client/view/page/space/space_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../state/screen_state.dart';
import '../component/space/space_grid_item.dart';
import '../widget/desktop_nav_button.dart';

class SpaceScreen extends StatefulWidget {
  const SpaceScreen({super.key});

  @override
  State<SpaceScreen> createState() => _SpaceScreenState();
}

class _SpaceScreenState extends State<SpaceScreen> {
  List<Space> searchSpaceList = <Space>[];
  List<Space> mySpaceList = <Space>[];

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    return Navigator(
      onGenerateRoute: (val) {
        return PageRouteBuilder(
          pageBuilder: (BuildContext nContext, Animation<double> animation, Animation<double> secondaryAnimation) {
            return Row(
              children: [
                SizedBox(
                  width: 180,
                  child: Row(
                    children: [
                      VerticalDivider(color: Colors.grey.withAlpha(100), width: 1),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(left: 10.0, top: 5.0, bottom: 5.0),
                              child: const Text("我的空间", style: TextStyle(color: Colors.grey, fontSize: 12)),
                            ),
                            // 根据mySpaceList生成的导航列表
                            NavButton(
                              title: "异度空间",
                              iconData: Icons.square,
                              onPress: () {
                                // 点击后弹出空间详情页面
                                Navigator.push(
                                  nContext,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return SpacePage();
                                    },
                                  ),
                                );
                              },
                              index: SecondNav.workspace,
                              selectedIndex: 1,
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
                      Container(
                        height: 40,
                        margin: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0, bottom: 10.0),
                        child: CupertinoSearchTextField(
                          style: TextStyle(color: colorScheme.onSurface, fontSize: 16),
                          placeholder: "",
                          prefixIcon: Icon(
                            CupertinoIcons.search,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          prefixInsets: const EdgeInsets.only(top: 1, left: 5, right: 2),
                          suffixIcon: Icon(
                            CupertinoIcons.xmark_circle_fill,
                            color: colorScheme.onSurface,
                          ),
                          onSubmitted: (value) {},
                        ),
                      ),
                      // 搜索到的空间列表，searchSpaceList
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(left: 15),
                          child: GridView.builder(
                            padding: const EdgeInsets.only(right: 15),
                            controller: ScrollController(),
                            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 240,
                              childAspectRatio: 2.5,
                              mainAxisSpacing: 5,
                              crossAxisSpacing: 5,
                            ),
                            itemCount: 11,
                            itemBuilder: (context, index) {
                              return SpaceGridItem();
                            },
                          ),
                        ),
                      ),
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
