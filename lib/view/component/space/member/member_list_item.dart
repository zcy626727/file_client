import 'package:file_client/constant/space.dart';
import 'package:file_client/model/space/space_user.dart';
import 'package:file_client/service/team/space_user_service.dart';
import 'package:file_client/view/component/space/member/member_edit_group_dialog.dart';
import 'package:flutter/material.dart';

import '../../../../constant/ui.dart';
import '../../../widget/confirm_alert_dialog.dart';
import '../../show/show_snack_bar.dart';

class MemberListItem extends StatelessWidget {
  const MemberListItem({super.key, required this.spaceUser, this.onDelete});

  final SpaceUser spaceUser;
  final Function(SpaceUser)? onDelete;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: containerBorder,
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: CircleAvatar(
          //头像半径
          radius: 30,
          backgroundImage: spaceUser.user?.avatarUrl == null ? null : NetworkImage(spaceUser.user!.avatarUrl!),
          backgroundColor: colorScheme.primary,
        ),
        title: Row(
          children: [
            Text(
              spaceUser.user?.name ?? "————",
              style: TextStyle(color: colorScheme.onPrimaryContainer, fontSize: 15),
              overflow: TextOverflow.ellipsis,
            )
            // 身份
          ],
        ),
        subtitle: Text(
          SpaceUserPermission.getRole(spaceUser.userPermission),
          style: TextStyle(color: colorScheme.onPrimaryContainer.withAlpha(100), fontSize: 12),
          overflow: TextOverflow.ellipsis,
        ),
        trailing: SizedBox(
          width: 150,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 5),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  tooltip: "编辑分组",
                  onPressed: () {
                    //弹出分配组列表
                    showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (BuildContext context) {
                        return MemberEditGroupDialog(spaceUser: spaceUser);
                      },
                    );
                  },
                  icon: const Icon(Icons.group, size: 20),
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 5),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  tooltip: "移除成员",
                  onPressed: () {
                    //弹出对话框
                    showDialog(
                      context: context,
                      builder: (BuildContext dialogContext) {
                        return ConfirmAlertDialog(
                          text: "是否确定移除成员？",
                          onCancel: () {
                            Navigator.pop(dialogContext);
                          },
                          onConfirm: () async {
                            try {
                              if (spaceUser.id == null) throw const FormatException("成员信息异常");
                              await SpaceUserService.removeUser(spaceUserId: spaceUser.id!);
                              if (dialogContext.mounted) Navigator.pop(dialogContext);
                              if (dialogContext.mounted) ShowSnackBar.info(context: context, message: "处理成功");
                              if (onDelete != null) onDelete!(spaceUser);
                            } on Exception catch (e) {
                              if (dialogContext.mounted) ShowSnackBar.exception(context: dialogContext, e: e);
                            }
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
    );
  }
}
