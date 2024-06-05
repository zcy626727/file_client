import 'package:flutter/material.dart';

import '../../../domain/task/enum/upload.dart';
import '../../../domain/task/multipart_upload_task.dart';
import '../../../util/file_util.dart';

class UploadListViewItem extends StatefulWidget {
  const UploadListViewItem({Key? key, required this.task, required this.onStartOrPause, required this.onCancel}) : super(key: key);

  final MultipartUploadTask task;
  final Function() onStartOrPause;
  final Function() onCancel;

  @override
  State<UploadListViewItem> createState() => _UploadListViewItemState();
}

class _UploadListViewItemState extends State<UploadListViewItem> {
  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    bool needStart = widget.task.status != UploadTaskStatus.finished && widget.task.status != UploadTaskStatus.error;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 7.0),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              widget.task.fileName!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: colorScheme.onSurface),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              FileUtil.getUploadPercentage(widget.task.uploadedSize ?? 0, widget.task.totalSize ?? 0),
              style: TextStyle(color: colorScheme.onSurface),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              widget.task.statusMessage ?? "",
              style: TextStyle(color: colorScheme.onSurface),
            ),
          ),
          SizedBox(
            width: 100,
            child: Row(
              children: [
                if (needStart)
                  IconButton(
                    color: colorScheme.onSurface,
                    padding: EdgeInsets.zero,
                    iconSize: 20,
                    onPressed: widget.onStartOrPause,
                    icon: widget.task.status == UploadTaskStatus.uploading ? const Icon(Icons.pause) : const Icon(Icons.play_arrow),
                  ),
                if (!needStart) const SizedBox(width: 40),
                IconButton(
                  color: colorScheme.onSurface,
                  padding: EdgeInsets.zero,
                  iconSize: 20,
                  onPressed: widget.onCancel,
                  icon: const Icon(Icons.close_sharp),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
