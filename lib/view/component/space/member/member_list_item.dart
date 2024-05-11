import 'package:file_client/model/space/group.dart';
import 'package:file_client/model/user/user.dart';
import 'package:file_client/view/component/space/member/member_edit_group_dialog.dart';
import 'package:flutter/material.dart';

import '../../../../constant/ui.dart';
import '../../../widget/confirm_alert_dialog.dart';

class MemberListItem extends StatelessWidget {
  const MemberListItem({super.key, required this.user});

  final User user;

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
          backgroundImage: user.avatarUrl == null ? null : NetworkImage(user.avatarUrl!),
          backgroundColor: colorScheme.primary,
        ),
        title: Row(
          children: [
            Text(
              user.name ?? "",
              style: TextStyle(color: colorScheme.onPrimaryContainer, fontSize: 15),
              overflow: TextOverflow.ellipsis,
            )
            // 身份
          ],
        ),
        subtitle: Text(
          "组列表",
          style: TextStyle(color: colorScheme.onPrimaryContainer.withAlpha(100), fontSize: 12),
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Container(
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
                        return MemberEditGroupDialog(
                          groupList: [Group(), Group()],
                        );
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
                          onConfirm: () async {},
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
    );
  }
}
