import 'package:file_client/model/space/group.dart';
import 'package:file_client/model/space/space.dart';
import 'package:file_client/service/team/group_service.dart';
import 'package:file_client/view/component/show/show_snack_bar.dart';
import 'package:flutter/material.dart';

import '../../../widget/common_action_two_button.dart';
import '../../../widget/common_input_text_field.dart';

class GroupEditDialog extends StatefulWidget {
  const GroupEditDialog({
    super.key,
    required this.space,
    this.group,
    this.onCreateGroup,
    this.onUpdateGroup,
  });

  final Space space;
  final Group? group;

  final Function(Group)? onCreateGroup;
  final Function(Group)? onUpdateGroup;

  @override
  State<GroupEditDialog> createState() => _GroupEditDialogState();
}

class _GroupEditDialogState extends State<GroupEditDialog> {
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.group != null) {
      controller.text = widget.group!.name ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    return AlertDialog(
      surfaceTintColor: colorScheme.surface,
      backgroundColor: colorScheme.surface,
      content: SizedBox(
        width: 80,
        height: 40,
        child: Column(
          children: [
            CommonInputTextField(
              title: "分组名",
              controller: controller,
            ),
          ],
        ),
      ),
      contentPadding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
      actions: [
        CommonActionTwoButton(
          height: 35,
          onLeftTap: () {
            Navigator.pop(context);
          },
          onRightTap: () async {
            try {
              if (controller.text.isEmpty) throw const FormatException("文件名为空");
              if (widget.group != null) {
                if (widget.group!.spaceId == null) throw const FormatException("空间信息异常");
                await GroupService.updateGroup(groupId: widget.group!.id!, newName: controller.text);
                widget.group!.name = controller.text;
                if (widget.onUpdateGroup != null) widget.onUpdateGroup!(widget.group!);
                if (context.mounted) ShowSnackBar.info(context: context, message: "更新成功");
              } else {
                if (widget.space.id == null) throw const FormatException("空间信息异常");
                var group = await GroupService.createGroup(name: controller.text, spaceId: widget.space.id!);
                if (widget.onCreateGroup != null) widget.onCreateGroup!(group);
                if (context.mounted) ShowSnackBar.info(context: context, message: "创建成功");
              }
              if (context.mounted) Navigator.pop(context);
            } on Exception catch (e) {
              if (context.mounted) ShowSnackBar.exception(context: context, e: e);
            }
          },
          rightTitle: widget.group == null ? "创建" : "更新",
        )
      ],
    );
  }
}
