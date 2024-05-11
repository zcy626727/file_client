import 'package:file_client/model/space/group.dart';
import 'package:flutter/material.dart';

import '../../../../constant/ui.dart';
import '../../../widget/confirm_alert_dialog.dart';

class GroupListItem extends StatelessWidget {
  const GroupListItem({super.key, required this.group});

  final Group group;

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
            // subtitle: Text(
            //   "组介绍",
            //   style: TextStyle(color: colorScheme.onPrimaryContainer.withAlpha(100), fontSize: 12),
            //   overflow: TextOverflow.ellipsis,
            // ),
            trailing: Container(
              width: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
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
        ));
  }
}
