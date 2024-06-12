import 'package:flutter/material.dart';

import 'common_action_two_button.dart';


class ConfirmAlertDialog extends StatelessWidget {
  const ConfirmAlertDialog({Key? key, required this.text, required this.onConfirm, required this.onCancel}) : super(key: key);

  final Function onConfirm;
  final Function onCancel;

  final String text;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AlertDialog(
        backgroundColor: colorScheme.surface,
        content: Text(
          text,
          style: TextStyle(color: colorScheme.onSurface.withAlpha(200)),
        ),
        actions: <Widget>[
          CommonActionTwoButton(
            height: 35,
            onLeftTap: onCancel,
            onRightTap: onConfirm,
            rightTextColor: colorScheme.onPrimary,
            backgroundRightColor: colorScheme.primary,
          )
        ],
      ),
    );
  }
}
