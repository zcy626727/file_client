import 'package:file_client/model/space/space_message.dart';
import 'package:file_client/service/team/space_message_service.dart';
import 'package:file_client/view/component/space/message/space_message_list_item.dart';
import 'package:flutter/material.dart';

import '../../../common/list/common_item_list.dart';
import '../../../model/space/space.dart';
import '../../widget/common_tab_bar.dart';

class SpaceMessagePage extends StatefulWidget {
  const SpaceMessagePage({super.key, required this.space});

  final Space space;

  @override
  State<SpaceMessagePage> createState() => _SpaceMessagePageState();
}

class _SpaceMessagePageState extends State<SpaceMessagePage> {
  late Future _futureBuilderFuture;

  GlobalKey<CommonItemListState<SpaceMessage>> listKey = GlobalKey<CommonItemListState<SpaceMessage>>();

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
            body: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  const CommonTabBar(
                    titleTextList: ["申请信息", "其他消息"],
                  ),
                  Expanded(
                    child: CommonItemList<SpaceMessage>(
                      key: listKey,
                      onLoad: (int page) async {
                        var list = await SpaceMessageService.getJoinMessageBySpace(spaceId: widget.space.id!, pageIndex: page);
                        return list;
                      },
                      itemName: "消息",
                      itemHeight: 40,
                      enableScrollbar: true,
                      isGrip: false,
                      itemBuilder: (ctx, item, itemList, onFresh) {
                        return SpaceMessageListItem(
                          message: item,
                          onDelete: (sm) {
                            itemList?.remove(item);
                            onFresh();
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
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
