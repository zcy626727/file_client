import 'package:file_client/model/space/space.dart';
import 'package:file_client/service/team/space_message_service.dart';
import 'package:file_client/view/component/show/show_snack_bar.dart';
import 'package:file_client/view/widget/common_input_text_field.dart';
import 'package:flutter/material.dart';

import '../../../constant/ui.dart';
import '../../widget/common_action_two_button.dart';

class JoinSpaceDialog extends StatefulWidget {
  const JoinSpaceDialog({super.key, required this.space});

  final Space space;

  @override
  State<JoinSpaceDialog> createState() => _JoinSpaceDialogState();
}

class _JoinSpaceDialogState extends State<JoinSpaceDialog> {
  final TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    return AlertDialog(
      backgroundColor: colorScheme.surface,
      title: Text("发送申请", style: TextStyle(color: colorScheme.onSurface, fontSize: dialogTitleFontSize)),
      content: SizedBox(
        width: 80,
        child: CommonInputTextField(maxLines: 5, maxLength: 100, title: "申请信息", controller: messageController),
      ),
      actions: [
        CommonActionTwoButton(
          height: 35,
          onLeftTap: () {
            Navigator.pop(context);
          },
          onRightTap: () async {
            try {
              if (widget.space.id == null) throw const FormatException("空间异常");
              await SpaceMessageService.createJoin(spaceId: widget.space.id!, message: messageController.text);
              if (context.mounted) Navigator.pop(context);
            } on Exception catch (e) {
              if (context.mounted) ShowSnackBar.exception(context: context, e: e);
            }
          },
          rightTitle: "发送",
        )
      ],
    );
  }
}
