import 'package:file_client/view/component/space/member/select_group_dialog.dart';
import 'package:flutter/material.dart';

import '../../../../constant/ui.dart';
import '../../../../model/space/group.dart';
import '../../../widget/confirm_alert_dialog.dart';

class MemberEditGroupDialog extends StatefulWidget {
  const MemberEditGroupDialog({super.key, required this.groupList});

  final List<Group> groupList;

  @override
  State<MemberEditGroupDialog> createState() => _MemberEditGroupDialogState();
}

class _MemberEditGroupDialogState extends State<MemberEditGroupDialog> {
  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return AlertDialog(
      backgroundColor: colorScheme.surface,
      surfaceTintColor: Theme.of(context).colorScheme.surface,
      contentPadding: dialogContentPadding,
      title: Text("编辑分组", style: TextStyle(color: colorScheme.onSurface, fontSize: dialogTitleFontSize)),
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
                  builder: (BuildContext context) {
                    return SelectGroupDialog();
                  },
                );
              },
              child: Container(
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
            // 分组列表
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 5, bottom: 5),
                child: ListView.builder(
                  itemCount: widget.groupList.length,
                  itemBuilder: (BuildContext context, int index) {
                    var group = widget.groupList[index];
                    //点击后返回当前group
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
                          group.name ?? "111",
                          style: TextStyle(color: colorScheme.onSurface),
                        ),
                        trailing: SizedBox(
                          height: 30,
                          width: 30,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            tooltip: "移除成员",
                            onPressed: () {
                              //弹出对话框
                              showDialog(
                                context: context,
                                builder: (BuildContext dialogContext) {
                                  return ConfirmAlertDialog(
                                    text: "是否移除分组？",
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
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
