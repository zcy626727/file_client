import 'package:file_client/model/space/space.dart';
import 'package:file_client/service/team/space_user_service.dart';
import 'package:file_client/view/component/space/member/member_list_item.dart';
import 'package:file_client/view/widget/common_search_text_field.dart';
import 'package:flutter/material.dart';

import '../../../common/list/common_item_list.dart';
import '../../../model/space/space_user.dart';

class SpaceMemberPage extends StatefulWidget {
  const SpaceMemberPage({super.key, required this.space});

  final Space space;

  @override
  State<SpaceMemberPage> createState() => _SpaceMemberPageState();
}

class _SpaceMemberPageState extends State<SpaceMemberPage> {
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
            body: Column(
              children: [
                Container(margin: const EdgeInsets.only(top: 5, left: 5, right: 5), child: const CommonSearchTextField(height: 40)),
                Expanded(
                  child: CommonItemList<SpaceUser>(
                    onLoad: (int page) async {
                      if (widget.space.id == null) return <SpaceUser>[];
                      var list = await SpaceUserService.getSpaceUserList(spaceId: widget.space.id!, pageIndex: page);
                      return list;
                    },
                    itemName: "成员",
                    itemHeight: 40,
                    enableScrollbar: true,
                    isGrip: false,
                    itemBuilder: (ctx, item, itemList, onFresh) {
                      return Container(
                        margin: const EdgeInsets.only(top: 5, left: 5, right: 5),
                        child: MemberListItem(
                          spaceUser: item,
                          onDelete: (_) {
                            itemList?.remove(item);
                            onFresh();
                          },
                        ),
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
