import 'dart:developer';

import 'package:dio/dio.dart';
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
  List<Space> _mySpaceList = <Space>[];

  late Future _futureBuilderFuture;

  @override
  void initState() {
    super.initState();
    _futureBuilderFuture = getData();
  }

  Future getData() async {
    return Future.wait([loadMyFileList()]);
  }

  //获取我的空间列表
  Future<void> loadMyFileList() async {
    try {
      _mySpaceList = await SpaceService.getUserSpaceList().timeout(const Duration(seconds: 2));
    } on DioException catch (e) {
      log(e.toString());
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    return FutureBuilder(
      future: _futureBuilderFuture,
      builder: (BuildContext context, AsyncSnapshot snapShot) {
        if (snapShot.connectionState == ConnectionState.done) {
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
                                              _mySpaceList.add(space);
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
                                    child: ListView(
                                      children: [
                                        ...List.generate(
                                          _mySpaceList.length,
                                          (index) {
                                            Space space = _mySpaceList[index];
                                            return NavButton(
                                              title: space.name ?? "未知",
                                              iconData: Icons.square,
                                              onPress: () {
                                                // 点击后弹出空间详情页面
                                                Navigator.push(
                                                  nContext,
                                                  MaterialPageRoute(
                                                    builder: (context) {
                                                      return SpacePage(space: space);
                                                    },
                                                  ),
                                                );
                                              },
                                              index: SecondNav.workspace,
                                              selectedIndex: 1,
                                            );
                                          },
                                        ),
                                      ],
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
