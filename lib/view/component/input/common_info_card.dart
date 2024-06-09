import 'package:flutter/material.dart';

import '../../../common/file/task/single_upload_task.dart';
import '../../../common/file/widget/image_upload_card.dart';

class CommonInfoCard extends StatefulWidget {
  const CommonInfoCard({
    super.key,
    required this.coverUploadImage,
    required this.titleController,
    this.introductionController,
    this.onRefresh,
  });

  final SingleUploadTask coverUploadImage;
  final TextEditingController titleController;
  final TextEditingController? introductionController;
  final Function? onRefresh;

  @override
  State<CommonInfoCard> createState() => _CommonInfoCardState();
}

class _CommonInfoCardState extends State<CommonInfoCard> {
  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 1, top: 1),
          padding: const EdgeInsets.only(top: 15, bottom: 5, right: 5),
          color: colorScheme.surface,
          height: 110,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextFormField(
                  controller: widget.titleController,
                  maxLines: 4,
                  maxLength: 50,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "标题不能为空";
                    }
                    return null;
                  },
                  style: TextStyle(
                    color: colorScheme.onSurface,
                  ),
                  strutStyle: const StrutStyle(fontSize: 16),
                  decoration: InputDecoration(
                    isCollapsed: true,
                    //防止文本溢出时被白边覆盖
                    contentPadding: const EdgeInsets.only(left: 10.0, right: 2, bottom: 10, top: 10),
                    border: OutlineInputBorder(
                      //添加边框
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    labelText: "标题",
                    labelStyle: TextStyle(color: colorScheme.onSurface),
                    alignLabelWithHint: true,
                    counter: const SizedBox(),
                    errorStyle: const TextStyle(fontSize: 10),
                    counterStyle: TextStyle(color: colorScheme.onSurface),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 5, bottom: 0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: colorScheme.background,
                ),
                height: 80,
                width: 80,
                child: ImageUploadCard(key: ValueKey(widget.coverUploadImage.srcPath), task: widget.coverUploadImage),
              ),
            ],
          ),
        ),
        if (widget.introductionController != null)
          Container(
            margin: const EdgeInsets.only(bottom: 1),
            padding: const EdgeInsets.only(top: 15, bottom: 5, left: 2, right: 2),
            color: colorScheme.surface,
            height: 150,
            child: TextFormField(
              controller: widget.introductionController,
              maxLines: 3,
              maxLength: 100,
              style: TextStyle(
                color: colorScheme.onSurface,
              ),
              strutStyle: const StrutStyle(fontSize: 21),
              decoration: InputDecoration(
                isCollapsed: true,
                //防止文本溢出时被白边覆盖
                contentPadding: const EdgeInsets.only(left: 10.0, right: 2, bottom: 10, top: 10),
                border: OutlineInputBorder(
                  //添加边框
                  borderRadius: BorderRadius.circular(5.0),
                ),
                labelText: "简介",
                labelStyle: TextStyle(color: colorScheme.onSurface),
                alignLabelWithHint: true,
                counterStyle: TextStyle(color: colorScheme.onSurface),
              ),
            ),
          ),
      ],
    );
  }
}
