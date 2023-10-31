import 'package:flutter/material.dart';

import '../../../model/file/user_file.dart';
import '../../../model/file/user_folder.dart';
import '../../../service/file/share_service.dart';
import '../../../util/share.dart';
import '../../widget/common_action_two_button.dart';
import '../../widget/input_text_field.dart';

class CreateShareDialog extends StatefulWidget {
  const CreateShareDialog({
    Key? key,
    required this.userFileList,
    required this.userFolderList,
    required this.shareName,
  }) : super(key: key);

  final List<UserFile> userFileList;
  final List<UserFolder> userFolderList;
  final String shareName;

  @override
  State<CreateShareDialog> createState() => _CreateShareDialogState();
}

class _CreateShareDialogState extends State<CreateShareDialog> {
  DateTime endTime = DateTime.now().add(const Duration(days: 7));
  TextEditingController dateTimeController = TextEditingController(text: "");
  var codeController = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    dateTimeController.text = endTime.toString().split(' ')[0];
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: InputTextField(controller: dateTimeController, title: "有效期至", enable: false)),
                const SizedBox(width: 5),
                SizedBox(
                  height: 42,
                  width: 42,
                  child: OutlinedButton(
                    onPressed: () async {
                      var selectedDateTime = await showDatePicker(
                        context: context,
                        initialDate: endTime,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      //更改显示的日期
                      if (selectedDateTime != null) {
                        setState(() {
                          dateTimeController.text = selectedDateTime.toString().split(' ')[0];
                          endTime = selectedDateTime;
                        });
                      }
                    },
                    style: ButtonStyle(padding: MaterialStateProperty.all(EdgeInsets.zero)),
                    child: const Icon(
                      Icons.calendar_month,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
            //有效期（单选）
            //是否需要提取码
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: InputTextField(
                  controller: codeController,
                  title: "提取码",
                  enable: true,
                  hintText: "无提取码",
                  maxLength: 10,
                )),
                const SizedBox(width: 5),
                SizedBox(
                  height: 42,
                  width: 42,
                  child: OutlinedButton(
                    onPressed: () {
                      codeController.text = ShareUtil.generateCode(len: 4);
                      setState(() {});
                    },
                    style: ButtonStyle(padding: MaterialStateProperty.all(EdgeInsets.zero)),
                    child: const Icon(
                      Icons.refresh,
                      size: 20,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      actions: <Widget>[
        CommonActionTwoButton(
          height: 35,
          onLeftTap: () {
            Navigator.of(context).pop();
          },
          rightTextColor: colorScheme.onPrimary,
          backgroundRightColor: colorScheme.primary,
          onRightTap: () async {
            var share = await ShareService.createShare(widget.userFileList, widget.userFolderList, endTime, codeController.text, widget.shareName);
            if (mounted) Navigator.of(context).pop(share);
          },
        )
      ],
    );
  }
}
