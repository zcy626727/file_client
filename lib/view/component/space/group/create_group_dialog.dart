import 'package:file_client/model/space/group.dart';
import 'package:file_client/model/space/space.dart';
import 'package:file_client/service/team/group_service.dart';
import 'package:file_client/view/component/show/show_snack_bar.dart';
import 'package:flutter/material.dart';

import '../../../widget/common_action_two_button.dart';
import '../../../widget/common_input_text_field.dart';

class CreateGroupDialog extends StatefulWidget {
  const CreateGroupDialog({super.key, required this.space, this.onCreateGroup});

  final Space space;

  final Function(Group)? onCreateGroup;

  @override
  State<CreateGroupDialog> createState() => _CreateGroupDialogState();
}

class _CreateGroupDialogState extends State<CreateGroupDialog> {
  final TextEditingController controller = TextEditingController();

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
              if (widget.space.id == null) throw const FormatException("空间信息异常");
              var group = await GroupService.createGroup(name: controller.text, spaceId: widget.space.id!);
              if (widget.onCreateGroup != null) widget.onCreateGroup!(group);
              if (context.mounted) ShowSnackBar.info(context: context, message: "创建成功");
              if (context.mounted) Navigator.pop(context);
            } on Exception catch (e) {
              if (context.mounted) ShowSnackBar.exception(context: context, e: e);
            }
          },
          rightTitle: "创建",
        )
      ],
    );
  }
}
