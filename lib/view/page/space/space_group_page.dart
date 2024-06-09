import 'package:file_client/common/list/common_item_list.dart';
import 'package:file_client/model/space/group.dart';
import 'package:file_client/service/team/group_service.dart';
import 'package:file_client/view/component/space/group/create_group_dialog.dart';
import 'package:file_client/view/component/space/group/group_list_item.dart';
import 'package:flutter/material.dart';

import '../../../model/space/space.dart';
import '../../widget/common_action_one_button.dart';
import '../../widget/common_search_text_field.dart';

class SpaceGroupPage extends StatefulWidget {
  const SpaceGroupPage({super.key, required this.space});

  final Space space;

  @override
  State<SpaceGroupPage> createState() => _SpaceGroupPageState();
}

class _SpaceGroupPageState extends State<SpaceGroupPage> {
  late Future _futureBuilderFuture;

  GlobalKey<CommonItemListState<Group>> listKey = GlobalKey<CommonItemListState<Group>>();

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
            body: Column(
              children: [
                const CommonSearchTextField(height: 60),
                Container(
                  height: 40,
                  margin: const EdgeInsets.only(top: 1, bottom: 1),
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  color: colorScheme.surface,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 30,
                        width: 120,
                        child: CommonActionOneButton(
                          title: "新建分组",
                          onTap: () async {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return CreateGroupDialog(
                                  space: widget.space,
                                  onCreateGroup: (group) {
                                    listKey.currentState?.addItem(group);
                                    listKey.currentState?.setState(() {});
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: CommonItemList<Group>(
                    key: listKey,
                    onLoad: (int page) async {
                      var list = await GroupService.getSpaceGroupList(spaceId: widget.space.id!);
                      return list;
                    },
                    itemName: "用户组",
                    itemHeight: 40,
                    enableScrollbar: true,
                    isGrip: false,
                    itemBuilder: (ctx, item, itemList, onFresh) {
                      return GroupListItem(
                        group: item,
                        onDeleteGroup: (group) {
                          listKey.currentState?.removeItem(group);
                          listKey.currentState?.setState(() {});
                        },
                      );
                    },
                  ),
                ),
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
