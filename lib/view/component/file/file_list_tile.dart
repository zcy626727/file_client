import 'package:flutter/material.dart';

import '../../../domain/resource.dart';
import '../../../constant/resource.dart';
import '../../../model/file/trash.dart';
import '../../../model/file/user_file.dart';
import '../../../model/file/user_folder.dart';
import '../../widget/custom_ink_well.dart';

class FileListItem extends StatefulWidget {
  const FileListItem({
    Key? key,
    required this.resource,
    this.onTap,
    this.onDoubleTap,
    this.selected = false,
    this.onPreTap,
    this.onSecondaryTap,
    this.onLongTap,
    //网格视图或列表视图
    this.isGrid = true,
    this.onCheck,
    this.isCheckMode = false,
  }) : super(key: key);

  final Resource resource;
  final GestureTapCallback? onTap;
  final GestureTapCallback? onDoubleTap;
  final GestureTapCallback? onPreTap;
  final GestureTapDownCallback? onSecondaryTap;
  final GestureLongPressStartCallback? onLongTap;
  final Function(bool)? onCheck;
  final bool selected;
  final bool isGrid;
  final bool isCheckMode;

  @override
  State<FileListItem> createState() => _FileListItemState();
}

class _FileListItemState extends State<FileListItem> {
  bool? check = false;

  @override
  Widget build(BuildContext context) {
    dynamic res = widget.resource;
    if (res is UserFile) {
      return userFileBuild(res);
    } else if (res is UserFolder) {
      return userFolderBuild(res);
    } else if (res is Trash) {
      if (res.type == ResourceType.file.index) {
        return userFileBuild(res);
      } else {
        return userFolderBuild(res);
      }
    } else {
      return const Placeholder();
    }
  }

  Widget userFileBuild(Resource file) {
    IconData iconData = Icons.insert_drive_file;
    var type = file.name!.split('.').last;
    switch (type) {
      case "png":
      case "jpeg":
      case "jpg":
        iconData = Icons.image;
        break;
      case "mp3": //音频
      case "m4a": //音频
        iconData = Icons.audio_file;
        break;
      case "mp4": //视频
        iconData = Icons.video_file;
        break;
      case "txt": //文本文件
        iconData = Icons.text_snippet;
        break;
    }

    Color iconColor = Colors.orange;
    if (file.status == ResourceStatus.uploading.index) {
      iconColor = iconColor.withAlpha(100);
    }

    String? coverUrl;

    if (file is UserFile) {
      coverUrl = file.coverUrl;
    }

    return buildViewItem(name: file.name!, coverUrl: coverUrl, iconData: iconData, iconColor: iconColor);
  }

  //文件夹
  Widget userFolderBuild(Resource folder) {
    return buildViewItem(name: folder.name!, iconData: Icons.folder);
  }

  Widget buildViewItem({required String name, required IconData iconData, String? coverUrl, Color iconColor = Colors.orange}) {
    bool needCover = coverUrl != null && coverUrl.isNotEmpty;
    var colorScheme = Theme.of(context).colorScheme;
    //网格视图item
    return Stack(
      fit: StackFit.expand,
      children: [
        Material(
          color: widget.selected ? Colors.grey.withAlpha(50) : Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(widget.isGrid ? 7.0 : 3.0)),
          ),
          clipBehavior: Clip.hardEdge,
          child: CustomInkWell(
            onPreTap: widget.onPreTap,
            onTap: widget.onTap,
            onDoubleTap: widget.onDoubleTap,
            onSecondaryTap: widget.onSecondaryTap,
            onLongTap: widget.onLongTap,
            doubleTapTime: const Duration(milliseconds: 200),
            child: widget.isGrid
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (needCover)
                        Image(
                          image: NetworkImage(coverUrl),
                          height: 75,
                          width: 75,
                        ),
                      if (!needCover) Icon(iconData, size: 75, color: iconColor),
                      Container(
                        margin: const EdgeInsets.only(left: 5, right: 5, top: 10),
                        child: Text(
                          name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      )
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    //todo 列表视图需要展示的数据更多（文件大小、上传时间等），可能需要再拆分一个方法，判断类型后针对每个类型展示信息
                    children: [
                      Icon(
                        iconData,
                        size: 35,
                        color: Colors.orange,
                      ),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(left: 5, right: 5, top: 10),
                          child: Text(
                            name,
                            style: const TextStyle(color: Colors.grey),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
        if (widget.isCheckMode)
          Positioned(
            right: 0,
            top: 0,
            child: Checkbox(
              value: check,
              activeColor: colorScheme.primary,
              checkColor: colorScheme.onPrimary,
              side: MaterialStateBorderSide.resolveWith((states) => BorderSide(width: 1.0, color: colorScheme.primary)),
              onChanged: (b) {
                setState(() {
                  check = b;
                });
                if (widget.onCheck != null) {
                  widget.onCheck!(b ?? false);
                }
              },
            ),
          ),
      ],
    );
  }
}
