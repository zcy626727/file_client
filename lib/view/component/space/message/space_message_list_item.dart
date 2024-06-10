import 'package:file_client/model/space/space_message.dart';
import 'package:flutter/material.dart';

import '../../../widget/confirm_alert_dialog.dart';

class SpaceMessageListItem extends StatefulWidget {
  const SpaceMessageListItem({super.key, required this.message});

  final SpaceMessage message;

  @override
  State<SpaceMessageListItem> createState() => _SpaceMessageListItemState();
}

class _SpaceMessageListItemState extends State<SpaceMessageListItem> {
  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(top: 5, left: 5, right: 15),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        contentPadding: const EdgeInsets.only(right: 5),
        leading: CircleAvatar(
          //头像半径
          radius: 30,
          backgroundImage: widget.message.user?.avatarUrl == null ? null : NetworkImage(widget.message.user!.avatarUrl!),
          backgroundColor: colorScheme.primary,
        ),
        title: Text(
          widget.message.user?.name ?? "————",
          style: TextStyle(color: colorScheme.onPrimaryContainer, fontSize: 15),
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          widget.message.message ?? "————",
          style: TextStyle(color: colorScheme.onPrimaryContainer.withAlpha(100), fontSize: 12),
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Container(
          width: 200,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                tooltip: "同意",
                onPressed: () {
                  //弹出对话框
                  showDialog(
                    context: context,
                    builder: (BuildContext dialogContext) {
                      return ConfirmAlertDialog(
                        text: "是否同意？",
                        onConfirm: () async {},
                        onCancel: () {
                          Navigator.pop(dialogContext);
                        },
                      );
                    },
                  );
                },
                icon: const Icon(Icons.done, size: 20),
                color: colorScheme.onPrimaryContainer,
              ),
              IconButton(
                padding: EdgeInsets.zero,
                tooltip: "拒绝",
                onPressed: () {
                  //弹出对话框
                  showDialog(
                    context: context,
                    builder: (BuildContext dialogContext) {
                      return ConfirmAlertDialog(
                        text: "是否拒绝？",
                        onConfirm: () async {},
                        onCancel: () {
                          Navigator.pop(dialogContext);
                        },
                      );
                    },
                  );
                },
                icon: const Icon(Icons.clear, size: 20),
                color: colorScheme.onPrimaryContainer,
              )
            ],
          ),
        ),
      ),
    );
  }
}
