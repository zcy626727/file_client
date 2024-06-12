import 'package:file_client/model/space/space_user.dart';
import 'package:file_client/service/team/group_service.dart';
import 'package:file_client/service/team/group_user_service.dart';
import 'package:file_client/view/component/show/show_snack_bar.dart';
import 'package:file_client/view/component/space/member/select_group_dialog.dart';
import 'package:file_client/view/component/space/member/user_group_list_item.dart';
import 'package:file_client/view/widget/common_action_one_button.dart';
import 'package:flutter/material.dart';

import '../../../../common/list/common_item_list.dart';
import '../../../../constant/ui.dart';
import '../../../../model/space/group.dart';

class MemberEditGroupDialog extends StatefulWidget {
  const MemberEditGroupDialog({super.key, required this.spaceUser});

  final SpaceUser spaceUser;

  @override
  State<MemberEditGroupDialog> createState() => _MemberEditGroupDialogState();
}

class _MemberEditGroupDialogState extends State<MemberEditGroupDialog> {
  GlobalKey<CommonItemListState<Group>> _groupListKey = GlobalKey<CommonItemListState<Group>>();

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AlertDialog(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Theme.of(context).colorScheme.surface,
        contentPadding: dialogContentPadding,
        title: Text("编辑组", style: TextStyle(color: colorScheme.onSurface, fontSize: dialogTitleFontSize)),
        content: SizedBox(
          width: 300,
          height: 400,
          child: Column(
            children: [
              // 点击后弹出搜索框，搜搜分组，单机后选择分组
              GestureDetector(
                onTap: () {
                  showDialog(
                    barrierDismissible: true,
                    context: context,
                    builder: (BuildContext dialogContext) {
                      return SelectGroupDialog(
                        spaceId: widget.spaceUser.spaceId!,
                        selectGroup: (g) async {
                          //添加组
                          try {
                            await GroupUserService.addGroup(groupId: g.id!, targetUserId: widget.spaceUser.userId!);
                            _groupListKey.currentState?.addItem(g);
                            _groupListKey.currentState?.setState(() {});
                          } on Exception catch (e) {
                            if (context.mounted) ShowSnackBar.exception(context: context, e: e);
                          }
                        },
                      );
                    },
                  );
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 10),
                  height: 35,
                  decoration: BoxDecoration(
                    color: colorScheme.onSurface.withAlpha(20),
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Center(
                    child: Text(
                      "添加分组",
                      style: TextStyle(color: colorScheme.onSurface.withAlpha(100), fontSize: 16),
                    ),
                  ),
                ),
              ),
              //用户已有组列表
              Expanded(
                child: CommonItemList<Group>(
                  onLoad: (int page) async {
                    if (widget.spaceUser.spaceId == null || widget.spaceUser.userId == null) return <Group>[];
                    var list = await GroupService.getSpaceGroupListByUser(spaceId: widget.spaceUser.spaceId!, targetUserId: widget.spaceUser.userId!, pageIndex: page);
                    return list;
                  },
                  key: _groupListKey,
                  itemName: "组",
                  itemHeight: 40,
                  enableScrollbar: true,
                  isGrip: false,
                  itemBuilder: (ctx, item, itemList, onFresh) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 2),
                      child: UserGroupListItem(
                        group: item,
                        userId: widget.spaceUser.userId!,
                        onDelete: (_) {
                          itemList?.remove(item);
                          if (context.mounted) ShowSnackBar.info(context: context, message: "移除成功");
                          onFresh();
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          CommonActionOneButton(
            height: 35,
            onTap: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }
}
