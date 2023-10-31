import 'package:flutter/material.dart';

import 'common_action_two_button.dart';


class InputAlertDialog extends StatelessWidget {
  const InputAlertDialog({
    Key? key,
    required this.onConfirm,
    required this.onCancel,
    required this.title,
    this.initValue,
    required this.iconData,
    this.maxLength,
  }) : super(key: key);

  final Function onConfirm;
  final Function onCancel;
  final String title;
  final String? initValue;
  final IconData iconData;
  final int? maxLength;

  // final bool height;

  @override
  Widget build(BuildContext context) {
    var controller = TextEditingController(text: initValue);
    var colorScheme = Theme.of(context).colorScheme;
    return AlertDialog(
      backgroundColor: colorScheme.surface,
      contentPadding: const EdgeInsets.only(
        left: 10.0,
        right: 10.0,
        top: 15.0,
      ),
      content: SizedBox(
        height: 65,
        width: 200,
        child: TextField(
          controller: controller,
          maxLines: 1,
          maxLength: maxLength,
          style: TextStyle(
            color: colorScheme.onSurface,
          ),
          strutStyle: const StrutStyle(fontSize: 21),
          decoration: InputDecoration(
            isCollapsed: true,
            //防止文本溢出时被白边覆盖
            contentPadding: const EdgeInsets.only(
                left: 12.0, right: 2, bottom: -3, top: 10),
            border: OutlineInputBorder(
              //添加边框
              borderRadius: BorderRadius.circular(5.0),
            ),
            label: Text(
              title,
              style: TextStyle(
                color:
                    Theme.of(context).colorScheme.onBackground.withAlpha(150),
              ),
              strutStyle: const StrutStyle(fontSize: 16),
            ),
            suffixIcon: Icon(
              iconData,
              color: Theme.of(context).colorScheme.primary,
            ),
            counterStyle: TextStyle(color: colorScheme.onSurface),
          ),
          keyboardType: TextInputType.text,
        ),
      ),
      actionsPadding:
          const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      actions: <Widget>[
        CommonActionTwoButton(
          height: 35,
          onLeftTap: () {
            onCancel();
          },
          onRightTap: () {
            onConfirm(controller.value.text);
          },
        )
      ],
    );
  }
}
