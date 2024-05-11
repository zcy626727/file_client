import 'package:flutter/material.dart';

import '../../../constant/ui.dart';
import '../../widget/common_action_two_button.dart';
import '../../widget/common_input_text_field.dart';

class SpaceSettingDialog extends StatefulWidget {
  const SpaceSettingDialog({super.key});

  @override
  State<SpaceSettingDialog> createState() => _SpaceSettingDialogState();
}

class _SpaceSettingDialogState extends State<SpaceSettingDialog> {
  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    return AlertDialog(
      backgroundColor: colorScheme.surface,
      title: Text("空间设置", style: TextStyle(color: colorScheme.onSurface, fontSize: dialogTitleFontSize)),
      content: SizedBox(
        width: 80,
        height: 170,
        child: Column(
          children: [
            CommonInputTextField(
              title: "空间名",
            ),
            SizedBox(height: 20),
            CommonInputTextField(
              title: "简介",
              maxLines: 4,
            )
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
          rightTitle: "确定",
        )
      ],
    );
  }
}
