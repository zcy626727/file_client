import 'package:file_client/constant/album.dart';
import 'package:file_client/model/share/topic.dart';
import 'package:file_client/view/component/show/show_snack_bar.dart';
import 'package:flutter/material.dart';

import '../../../common/file/constant/upload.dart';
import '../../../common/file/task/single_upload_task.dart';
import '../../widget/common_action_two_button.dart';
import '../../widget/common_dropdown.dart';
import '../input/common_info_card.dart';

class TopicEditDialog extends StatefulWidget {
  const TopicEditDialog({
    Key? key,
    required this.onCreate,
    this.option,
    this.initTopic,
  }) : super(key: key);
  final Topic? initTopic;
  final Function(String title, String introduction, String? coverUrl, int albumType) onCreate;
  final List<(int, String)>? option;

  @override
  State<TopicEditDialog> createState() => _TopicEditDialogState();
}

class _TopicEditDialogState extends State<TopicEditDialog> {
  DateTime endTime = DateTime.now().add(const Duration(days: 7));
  TextEditingController dateTimeController = TextEditingController(text: "");
  var titleController = TextEditingController(text: "");
  var introductionController = TextEditingController(text: "");
  SingleUploadTask coverUploadImage = SingleUploadTask();
  (int, String) _selectedAlbumType = AlbumType.option[0];

  @override
  void initState() {
    super.initState();
    coverUploadImage.private = false;
    if (widget.initTopic != null) {
      titleController.text = widget.initTopic!.title ?? "";
      introductionController.text = widget.initTopic!.introduction ?? "";
      if (widget.initTopic!.coverUrl != null) {
        coverUploadImage.coverUrl = widget.initTopic!.coverUrl;
        coverUploadImage.status = UploadTaskStatus.finished;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    dateTimeController.text = endTime.toString().split(' ')[0];
    var colorScheme = Theme.of(context).colorScheme;
    return AlertDialog(
      backgroundColor: colorScheme.surface,
      contentPadding: const EdgeInsets.only(
        left: 5.0,
        right: 5.0,
        top: 15.0,
      ),
      content: SizedBox(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: CommonInfoCard(
                coverUploadImage: coverUploadImage,
                titleController: titleController,
                introductionController: introductionController,
              ),
            ),
            if (widget.option != null)
              CommonDropdown(
                title: "合集类型",
                onChanged: (value) {
                  setState(() {
                    _selectedAlbumType = value;
                  });
                },
                options: widget.option!,
              ),
          ],
        ),
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
      actions: <Widget>[
        CommonActionTwoButton(
          height: 35,
          onLeftTap: () {
            Navigator.of(context).pop();
          },
          rightTextColor: colorScheme.onPrimary,
          backgroundRightColor: colorScheme.primary,
          onRightTap: () async {
            try {
              if (titleController.text.isEmpty) throw const FormatException("错误");
              if (introductionController.text.isEmpty) throw const FormatException("没有简介错误");
              if (coverUploadImage.status != UploadTaskStatus.finished) throw const FormatException("封面未上传完毕");
              if (coverUploadImage.coverUrl == null || coverUploadImage.coverUrl!.isEmpty) throw const FormatException("没上传封面");
              var title = titleController.text;
              var introduction = introductionController.text;
              await widget.onCreate(title, introduction, coverUploadImage.coverUrl, _selectedAlbumType.$1);
            } on Exception catch (e) {
              if (context.mounted) ShowSnackBar.exception(context: context, e: e);
            }
            return false;
          },
        )
      ],
    );
  }
}
