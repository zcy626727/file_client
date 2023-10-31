import 'package:flutter/material.dart';

import '../../../domain/task/download_task.dart';
import '../../../domain/task/enum/upload.dart';
import '../../../domain/task/multipart_upload_task.dart';
import '../../../util/file_util.dart';

class DownloadListViewItem extends StatefulWidget {
  const DownloadListViewItem({Key? key, required this.task, required this.onStartOrPause, required this.onCancel}) : super(key: key);

  final DownloadTask task;
  final Function() onStartOrPause;
  final Function() onCancel;

  @override
  State<DownloadListViewItem> createState() => _DownloadListViewItemState();
}

class _DownloadListViewItemState extends State<DownloadListViewItem> {
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
              widget.task.targetName!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: colorScheme.onSurface),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              FileUtil.getUploadPercentage(widget.task.downloadedSize, widget.task.totalSize),
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
                    icon: widget.task.status == UploadTaskStatus.uploading || widget.task.status == UploadTaskStatus.awaiting ? const Icon(Icons.pause) : const Icon(Icons.play_arrow),
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
