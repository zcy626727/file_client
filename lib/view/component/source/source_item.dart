import 'package:dio/dio.dart';
import 'package:file_client/model/file/user_file.dart';
import 'package:file_client/model/share/audio.dart';
import 'package:file_client/model/share/source.dart';
import 'package:file_client/model/share/video.dart';
import 'package:file_client/service/share/audio_service.dart';
import 'package:file_client/service/share/video_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../page/preview/video_preview_page.dart';
import '../../page/source/audio_edit_page.dart';
import '../../page/source/video_edit_page.dart';
import '../../widget/confirm_alert_dialog.dart';
import '../show/show_snack_bar.dart';

class SourceItem extends StatefulWidget {
  const SourceItem({super.key, required this.source, required this.onDeleteSource});

  final Source source;
  final Function(Source) onDeleteSource;

  @override
  State<SourceItem> createState() => _SourceItemState();
}

class _SourceItemState extends State<SourceItem> {
  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return Container(
        color: colorScheme.surface,
        margin: const EdgeInsets.only(bottom: 1),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ListTile(
                onTap: () {
                  var f = widget.source;
                  if (f is Video) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return VideoPreviewPage(fileId: f.fileId!);
                        },
                      ),
                    );
                  } else if (f is Audio) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return VideoPreviewPage(fileId: f.fileId!);
                        },
                      ),
                    );
                  } //...
                },
                contentPadding: const EdgeInsets.only(left: 10),
                leading: widget.source.coverUrl == null || widget.source.coverUrl!.isEmpty
                    ? null
                    : Image.network(
                        widget.source.coverUrl!,
                        fit: BoxFit.cover,
                        width: 50,
                        height: 50,
                      ),
                title: Text(
                  widget.source.title ?? "没有名称",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: colorScheme.onSurface, fontSize: 15),
                ),
                subtitle: Text(
                  DateFormat("yyyy-MM-dd").format(widget.source.createTime!),
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                trailing: Container(
                  margin: const EdgeInsets.only(right: 50),
                  child: Text(
                    "#${widget.source.order ?? ""}",
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
            IconButton(
                onPressed: () {
                  editSource();
                },
                icon: Icon(
                  Icons.edit_note,
                  color: colorScheme.onSurface,
                )),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: PopupMenuButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(
                    width: 1,
                    color: colorScheme.onSurface.withAlpha(30),
                    style: BorderStyle.solid,
                  ),
                ),
                color: colorScheme.surface,
                child: Icon(
                  Icons.more_horiz,
                  color: colorScheme.onSurface,
                ),
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem(
                      value: "delete",
                      onTap: () async {
                        await deleteSource();
                      },
                      child: Text("删除", style: TextStyle(color: colorScheme.onSurface)),
                    ),
                  ];
                },
              ),
            )
          ],
        ));
  }

  //主题功能
  Future<void> deleteSource() async {
    await showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return ConfirmAlertDialog(
            text: "是否确定删除？",
            onConfirm: () async {
              try {
                var s = widget.source;
                if (s is Video) {
                  await VideoService.deleteVideo(videoId: s.id!);
                } else if (s is Audio) {
                  await AudioService.deleteAudio(audioId: s.id!);
                }
                await widget.onDeleteSource(widget.source);
              } on DioException catch (e) {
                ShowSnackBar.exception(context: context, e: e, defaultValue: "删除失败");
              } finally {
                Navigator.pop(dialogContext);
              }
            },
            onCancel: () {
              Navigator.pop(dialogContext);
            },
          );
        });
  }

  Future<void> editSource() async {
    if (widget.source is Audio) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (parentContext) {
            return AudioEditPage(
              initSource: widget.source,
              onCreate: (String title, String? coverUrl, int fileId,int order) async {
                try {
                  await AudioService.updateAudio(fileId: fileId, title: title, coverUrl: coverUrl, audioId: widget.source.id!,order:order);
                  widget.source.title = title;
                  widget.source.coverUrl = coverUrl;
                  widget.source.order = order;
                  setState(() {});
                } on Exception catch (e) {
                  ShowSnackBar.exception(context: context, e: e);
                }
              },
            );
          },
        ),
      );
    } else if (widget.source is Video) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (parentContext) {
            return VideoEditPage(
              initSource: widget.source,
              onCreate: (String title, String? coverUrl, int fileId,int order) async {
                try {
                  await VideoService.updateVideo(fileId: fileId, title: title, coverUrl: coverUrl, videoId: widget.source.id!,order:order);
                  widget.source.title = title;
                  widget.source.coverUrl = coverUrl;
                  widget.source.order = order;
                  setState(() {});
                } on Exception catch (e) {
                  ShowSnackBar.exception(context: context, e: e);
                }
              },
            );
          },
        ),
      );
    }
  }
}
