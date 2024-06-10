import 'package:file_client/model/space/group.dart';
import 'package:file_client/model/space/space.dart';
import 'package:file_client/service/team/group_service.dart';
import 'package:file_client/view/component/space/group/group_edit_dialog.dart';
import 'package:flutter/material.dart';

import '../../../../constant/ui.dart';
import '../../../widget/confirm_alert_dialog.dart';
import '../../show/show_snack_bar.dart';

class GroupListItem extends StatelessWidget {
  const GroupListItem({super.key, required this.group, this.onDeleteGroup, this.onUpdateGroup, required this.space});

  final Group group;
  final Space space;

  final Function(Group)? onDeleteGroup;
  final Function(Group)? onUpdateGroup;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15),
      margin: const EdgeInsets.only(top: 4, left: 5, right: 15),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: containerBorder,
      ),
      height: 60,
      child: Center(
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          title: Row(
            children: [
              Text(
                group.name ?? "未命名",
                style: TextStyle(color: colorScheme.onPrimaryContainer, fontSize: 15),
                overflow: TextOverflow.ellipsis,
              )
              // 身份
            ],
          ),
          trailing: SizedBox(
            width: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 5),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    tooltip: "修改分组",
                    onPressed: () {
                      //弹出对话框
                      showDialog(
                        context: context,
                        builder: (BuildContext dialogContext) {
                          return GroupEditDialog(
                            onUpdateGroup: (group) async {
                              if (onUpdateGroup != null) onUpdateGroup!(group);
                            },
                            group: group,
                            space: space,
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.edit, size: 20),
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 5),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    tooltip: "删除分组",
                    onPressed: () {
                      //弹出对话框
                      showDialog(
                        context: context,
                        builder: (BuildContext dialogContext) {
                          return ConfirmAlertDialog(
                            text: "是否确定删除分组？",
                            onConfirm: () async {
                              try {
                                if (group.id == null) throw const FormatException("组状态异常");
                                if (group.spaceId == null) throw const FormatException("空间状态异常");
                                await GroupService.deleteGroup(spaceId: group.spaceId!, groupId: group.id!);
                                if (onDeleteGroup != null) onDeleteGroup!(group);
                                if (dialogContext.mounted) ShowSnackBar.info(context: dialogContext, message: "删除成功");
                                if (dialogContext.mounted) Navigator.pop(dialogContext);
                              } on Exception catch (e) {
                                if (dialogContext.mounted) ShowSnackBar.exception(context: dialogContext, e: e);
                              }
                            },
                            onCancel: () {
                              Navigator.pop(dialogContext);
                            },
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.delete, size: 20),
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
