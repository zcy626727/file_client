import 'dart:developer';
import 'dart:io';
import 'dart:isolate';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../../domain/task/enum/upload.dart';
import '../../../domain/task/single_upload_task.dart';
import '../../../service/common/file_url_service.dart';
import '../../../service/common/upload_service.dart';
import '../../widget/confirm_alert_dialog.dart';
import '../show/show_snack_bar.dart';

class ImageUploadCard extends StatefulWidget {
  const ImageUploadCard({required super.key, required this.task, this.onDeleteImage, this.onUpdateImage, this.enableDelete = true});

  final SingleUploadTask task;
  final Function(SingleUploadTask)? onDeleteImage;
  final Function(SingleUploadTask)? onUpdateImage;
  final bool enableDelete;

  @override
  State<ImageUploadCard> createState() => _ImageUploadCardState();
}

class _ImageUploadCardState extends State<ImageUploadCard> {
  final double imagePadding = 5.0;
  final double imageWidth = 100;
  Isolate? isolate;

  late Future _futureBuilderFuture;

  @override
  void initState() {
    super.initState();
    //如果正在上传中
    if (widget.task.status == UploadTaskStatus.uploading) {
      uploadImage(widget.task);
    }
    _futureBuilderFuture = getData();
  }

  Future getData() async {
    return Future.wait([getImageUrl()]);
  }

  Future<void> getImageUrl() async {
    try {
      if (widget.task.fileId != null) {
        var (url, staticUrl) = await FileUrlService.genGetFileUrl(widget.task.fileId!);
        widget.task.coverUrl = staticUrl;
      }
    } on DioException catch (e) {
      log(e.toString());
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    DecorationImage? decorationImage;
    if (widget.task.srcPath != null) {
      decorationImage = DecorationImage(
        image: FileImage(File(widget.task.srcPath!)),
        fit: BoxFit.cover,
      );
    } else if (widget.task.coverUrl != null) {
      decorationImage = DecorationImage(
        image: NetworkImage(widget.task.coverUrl!),
        fit: BoxFit.cover,
      );
    }

    return FutureBuilder(
      future: _futureBuilderFuture,
      builder: (BuildContext context, AsyncSnapshot snapShot) {
        if (snapShot.connectionState == ConnectionState.done) {
          return GestureDetector(
            onTap: () async {
              //打开file picker
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                type: FileType.image,
              );
              if (result != null) {
                RandomAccessFile? read;
                try {
                  var file = result.files.single;
                  read = await File(result.files.single.path!).open();
                  //消息接收器
                  widget.task.srcPath = file.path;
                  widget.task.totalSize = file.size;
                  widget.task.private = false;
                  widget.task.status = UploadTaskStatus.uploading;
                  uploadImage(widget.task);
                } catch (e) {
                  widget.task.clear();
                } finally {
                  read?.close();
                }
                setState(() {});
              } else {
                // User canceled the picker
              }
            },
            onLongPress: widget.enableDelete
                ? () async {
                    await deleteImage();
                  }
                : null,
            child: Container(
              //上传成功前填充前景色为灰
              foregroundDecoration: widget.task.status == UploadTaskStatus.finished ? null : BoxDecoration(color: Colors.grey.withAlpha(100)),
              width: imageWidth,
              height: imageWidth,
              decoration: decorationImage == null
                  ? null
                  : BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      image: decorationImage,
                    ),
              child: decorationImage == null ? const Icon(Icons.cloud_upload) : null,
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          );
        }
      },
    );
  }

  Future<void> deleteImage() async {
    //展示弹出框，选择是否删除
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmAlertDialog(
          text: "是否确定删除？",
          onConfirm: () async {
            try {
              if (widget.onDeleteImage != null) {
                await widget.onDeleteImage!(widget.task);
              }
            } on DioException catch (e) {
              ShowSnackBar.exception(context: context, e: e, defaultValue: "删除失败");
            } finally {
              Navigator.pop(context);
            }
            if (isolate != null) {
              isolate!.kill();
            }
          },
          onCancel: () {
            Navigator.pop(context);
          },
        );
      },
    );
  }

  Future<void> uploadImage(SingleUploadTask task) async {
    await SingleUploadService.doUploadFile(
      task: widget.task,
      onError: (task) {},
      onSuccess: (task) async {
        if (widget.onUpdateImage != null) {
          await widget.onUpdateImage!(task);
        }
        var (link, staticUrl) = await FileUrlService.genGetFileUrl(task.fileId!);
        widget.task.coverUrl = staticUrl;
        setState(() {});
      },
      onUpload: (task) {},
      onAfterStart: (i) {
        isolate = i;
      },
    );
  }
}
