import 'package:file_client/model/space/space_message.dart';
import 'package:file_client/service/team/space_message_service.dart';
import 'package:file_client/view/component/show/show_snack_bar.dart';
import 'package:flutter/material.dart';

import '../../../widget/confirm_alert_dialog.dart';

class SpaceMessageListItem extends StatefulWidget {
  const SpaceMessageListItem({super.key, required this.message, this.onDelete});

  final SpaceMessage message;
  final Function(SpaceMessage)? onDelete;

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
                        onCancel: () {
                          Navigator.pop(dialogContext);
                        },
                        onConfirm: () async {
                          try {
                            if (widget.message.id == null) throw const FormatException("申请信息异常");
                            await SpaceMessageService.acceptJoin(msgId: widget.message.id!);
                            if (dialogContext.mounted) Navigator.pop(dialogContext);
                            if (dialogContext.mounted) ShowSnackBar.info(context: context, message: "处理成功");
                            if (widget.onDelete != null) widget.onDelete!(widget.message);
                          } on Exception catch (e) {
                            if (dialogContext.mounted) ShowSnackBar.exception(context: dialogContext, e: e);
                          }
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
                        onCancel: () {
                          Navigator.pop(dialogContext);
                        },
                        onConfirm: () async {
                          try {
                            if (widget.message.id == null) throw const FormatException("申请信息异常");
                            await SpaceMessageService.refuseJoin(msgId: widget.message.id!);
                            if (dialogContext.mounted) Navigator.pop(dialogContext);
                            if (dialogContext.mounted) ShowSnackBar.info(context: context, message: "处理成功");
                            if (widget.onDelete != null) widget.onDelete!(widget.message);
                          } on Exception catch (e) {
                            if (dialogContext.mounted) ShowSnackBar.exception(context: dialogContext, e: e);
                          }
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
