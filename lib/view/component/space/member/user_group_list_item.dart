import 'package:file_client/model/space/group.dart';
import 'package:file_client/service/team/group_user_service.dart';
import 'package:flutter/material.dart';

import '../../../widget/confirm_alert_dialog.dart';
import '../../show/show_snack_bar.dart';

class UserGroupListItem extends StatelessWidget {
  const UserGroupListItem({super.key, required this.group, this.onDelete, required this.userId});

  final Group group;
  final int userId;

  final Function(Group)? onDelete;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        key: ValueKey(group.id),
        title: Text(
          group.name ?? "————",
          style: TextStyle(color: colorScheme.onSurface),
        ),
        trailing: SizedBox(
          height: 30,
          width: 30,
          child: IconButton(
            padding: EdgeInsets.zero,
            tooltip: "移除分组",
            onPressed: () {
              //弹出对话框
              showDialog(
                context: context,
                builder: (BuildContext dialogContext) {
                  return ConfirmAlertDialog(
                    text: "是否移除分组？",
                    onConfirm: () async {
                      try {
                        if (group.id == null) throw const FormatException("组信息异常");
                        await GroupUserService.removeGroup(groupId: group.id!, targetUserId: userId);
                        if (dialogContext.mounted) Navigator.pop(dialogContext);
                        if (dialogContext.mounted) ShowSnackBar.info(context: context, message: "移除成功");
                        if (onDelete != null) onDelete!(group);
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
      ),
    );
  }
}
