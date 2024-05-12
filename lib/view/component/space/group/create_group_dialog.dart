import 'package:flutter/material.dart';

import '../../../../constant/ui.dart';
import '../../../widget/common_action_two_button.dart';
import '../../../widget/common_input_text_field.dart';

class CreateGroupDialog extends StatelessWidget {
  const CreateGroupDialog({super.key});

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    return AlertDialog(
      surfaceTintColor: colorScheme.surface,
      title: Text("空间设置", style: TextStyle(color: colorScheme.onSurface, fontSize: dialogTitleFontSize)),
      content: SizedBox(
        width: 80,
        height: 40,
        child: Column(
          children: [
            CommonInputTextField(
              title: "分组名",
            ),
          ],
        ),
      ),
      actions: [
        CommonActionTwoButton(
          height: 35,
          onLeftTap: () {
            Navigator.pop(context);
          },
          onRightTap: () {},
          rightTitle: "创建",
        )
      ],
    );
  }
}
