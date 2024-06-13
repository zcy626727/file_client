import 'package:file_client/util/share.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../model/file/share.dart';
import '../../widget/common_action_two_button.dart';
import '../../widget/input_text_field.dart';

class LinkShareDetailDialog extends StatelessWidget {
  const LinkShareDetailDialog({Key? key, required this.share}) : super(key: key);
  final Share share;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return AlertDialog(
      backgroundColor: colorScheme.surface,
      contentPadding: const EdgeInsets.only(
        left: 10.0,
        right: 10.0,
        top: 15.0,
      ),
      content: SizedBox(
        width: 100,
        height: 130,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: InputTextField(
                      controller: TextEditingController(text: share.token!),
                      title: "链接地址",
                      enable: false,
                    )),
                const SizedBox(width: 5),
                SizedBox(
                  height: 42,
                  width: 42,
                  child: OutlinedButton(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: share.token!));
                      //todo 以后整个提示
                    },
                    style: ButtonStyle(padding: MaterialStateProperty.all(EdgeInsets.zero)),
                    child: const Icon(
                      Icons.copy,
                      size: 20,
                    ),
                  ),
                )
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: InputTextField(
                      controller: TextEditingController(text: share.code != null && share.code!.isNotEmpty ? share.code : "无提取码"),
                      title: "提取码",
                      enable: false,
                    )),
                const SizedBox(width: 5),
                SizedBox(
                  height: 42,
                  width: 42,
                  child: OutlinedButton(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: share.code!));
                    },
                    style: ButtonStyle(padding: MaterialStateProperty.all(EdgeInsets.zero)),
                    child: const Icon(
                      Icons.copy,
                      size: 20,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
      actionsPadding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10),
      actions: <Widget>[
        CommonActionTwoButton(
          leftTitle: "返回",
          height: 35,
          onLeftTap: () {
            Navigator.of(context).pop();
          },
          backgroundRightColor: colorScheme.primary,
          rightTextColor: colorScheme.onPrimary,
          rightTitle: "复制完整链接",
          onRightTap: () {
            Clipboard.setData(ClipboardData(text: ShareUtil.generateShareUrl(token: share.token!, code: share.code)));
          },
        )
      ],
    );
  }
}
