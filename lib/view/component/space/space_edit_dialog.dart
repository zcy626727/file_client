import 'package:file_client/model/space/space.dart';
import 'package:file_client/service/team/space_service.dart';
import 'package:file_client/view/component/show/show_snack_bar.dart';
import 'package:flutter/material.dart';

import '../../../common/file/constant/upload.dart';
import '../../../common/file/task/single_upload_task.dart';
import '../../../common/file/widget/image_upload_card.dart';
import '../../../constant/ui.dart';
import '../../widget/common_action_two_button.dart';
import '../../widget/common_input_text_field.dart';

class SpaceEditDialog extends StatefulWidget {
  const SpaceEditDialog({super.key, this.space, this.onCreateSpace, this.onUpdateSpace});

  final Space? space;
  final Function(Space)? onCreateSpace;
  final Function(Space)? onUpdateSpace;

  @override
  State<SpaceEditDialog> createState() => _SpaceEditDialogState();
}

class _SpaceEditDialogState extends State<SpaceEditDialog> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  SingleUploadTask coverUploadImage = SingleUploadTask();

  @override
  void initState() {
    super.initState();
    //
    if (widget.space != null) {
      if (widget.space!.avatarUrl != null) {
        coverUploadImage.status = UploadTaskStatus.finished;
        coverUploadImage.coverUrl = widget.space!.avatarUrl;
      }
      nameController.text = widget.space!.name ?? "";
      descriptionController.text = widget.space!.description ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    return AlertDialog(
      backgroundColor: colorScheme.surface,
      surfaceTintColor: colorScheme.surface,
      title: Text("空间设置", style: TextStyle(color: colorScheme.onSurface, fontSize: dialogTitleFontSize)),
      content: SizedBox(
        // width: 80,
        height: 250,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 10, left: 1, right: 1),
              width: 70,
              height: 70,
              child: ImageUploadCard(task: coverUploadImage, radius: 50),
            ),
            CommonInputTextField(
              title: "空间名",
              controller: nameController,
            ),
            const SizedBox(height: 20),
            CommonInputTextField(
              title: "简介",
              maxLines: 4,
              controller: descriptionController,
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
          onRightTap: () async {
            try {
              if (nameController.value.text.isEmpty) throw const FormatException("名字为空");
              if (widget.space != null) {
                //更新
                await SpaceService.updateSpace(
                  spaceId: widget.space!.id!,
                  newName: nameController.value.text,
                  newAvatarUrl: coverUploadImage.coverUrl,
                  newDescription: descriptionController.value.text,
                );
                widget.space!.name = nameController.value.text;
                widget.space!.avatarUrl = coverUploadImage.coverUrl;
                widget.space!.description = descriptionController.value.text;
                if (widget.onUpdateSpace != null) widget.onUpdateSpace!(widget.space!);
              } else {
                //创建
                var space = await SpaceService.createCreate(
                  name: nameController.value.text,
                  avatarUrl: coverUploadImage.coverUrl,
                  description: descriptionController.value.text,
                );
                if (widget.onCreateSpace != null) widget.onCreateSpace!(space);
              }
              if (context.mounted) Navigator.pop(context);
            } on Exception catch (e) {
              if (context.mounted) ShowSnackBar.exception(context: context, e: e, defaultValue: "操作失败");
            }
          },
          rightTitle: widget.space == null ? "创建" : "修改",
        )
      ],
    );
  }
}
