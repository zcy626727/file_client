import 'package:flutter/material.dart';

import '../../../constant/ui.dart';
import '../../widget/common_action_two_button.dart';

class JoinSpaceDialog extends StatelessWidget {
  const JoinSpaceDialog({super.key});

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    return AlertDialog(
      backgroundColor: colorScheme.surface,
      title: Text("发送申请", style: TextStyle(color: colorScheme.onSurface, fontSize: dialogTitleFontSize)),
      content: Container(
        width: 80,
        child: TextField(
          decoration: InputDecoration(
            isCollapsed: true,
            //防止文本溢出时被白边覆盖
            contentPadding: const EdgeInsets.only(left: 10.0, right: 2, bottom: 10, top: 10),
            border: OutlineInputBorder(
              //添加边框
              borderRadius: BorderRadius.circular(5.0),
            ),
            labelText: "申请信息",
            labelStyle: TextStyle(color: colorScheme.onSurface),
            alignLabelWithHint: true,
            counterStyle: TextStyle(color: colorScheme.onSurface),
          ),
          maxLines: 5,
          maxLength: 100,
          style: TextStyle(color: colorScheme.onSurface),
        ),
      ),
      actions: [
        CommonActionTwoButton(
          height: 35,
          onLeftTap: () {
            Navigator.pop(context);
          },
          onRightTap: () {},
          rightTitle: "发送",
        )
      ],
    );
  }
}
