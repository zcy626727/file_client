import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:file_client/model/share/source.dart';
import 'package:file_client/view/component/input/common_info_card.dart';
import 'package:file_client/view/widget/common_action_one_button.dart';
import 'package:flutter/material.dart';

import '../../../common/file/constant/upload.dart';
import '../../../common/file/service/file_url_service.dart';
import '../../../common/file/task/single_upload_task.dart';
import '../../../constant/file.dart';
import '../../../model/file/user_file.dart';
import '../../../model/file/user_folder.dart';
import '../../../model/share/video.dart';
import '../../../service/file/user_file_service.dart';
import '../../component/file/select_resource_dialog.dart';
import '../../component/show/show_snack_bar.dart';
import '../../widget/common_action_two_button.dart';
import '../../widget/common_media_player.dart';
import '../../widget/common_text_field.dart';

class VideoEditPage extends StatefulWidget {
  const VideoEditPage({
    Key? key,
    required this.onCreate,
    this.initSource,
  }) : super(key: key);

  final Source? initSource;

  final Function(String title, String? coverUrl, int fileId, int order) onCreate;

  @override
  State<VideoEditPage> createState() => _VideoEditPageState();
}

class _VideoEditPageState extends State<VideoEditPage> {
  DateTime endTime = DateTime.now().add(const Duration(days: 7));
  TextEditingController dateTimeController = TextEditingController(text: "");
  TextEditingController orderController = TextEditingController(text: "");

  var titleController = TextEditingController(text: "");
  SingleUploadTask coverUploadImage = SingleUploadTask();
  UserFile? userFile;
  String? _currentUrl;

  late Future _futureBuilderFuture;

  Future<void> loadUrl() async {
    try {
      var s = widget.initSource;
      if (s != null && s is Video) {
        var (url, _) = await FileUrlService.genGetFileUrl(s.fileId!);
        _currentUrl = url;
      }
    } on DioException catch (e) {
      log(e.toString());
    } catch (e) {
      log(e.toString());
    }
  }

  Future getData() async {
    return Future.wait([loadUrl()]);
  }

  @override
  void initState() {
    super.initState();
    _futureBuilderFuture = getData();
    coverUploadImage.private = false;
    if (widget.initSource != null) {
      orderController.text = "${widget.initSource!.order}";
      titleController.text = widget.initSource!.title ?? "";
      if (widget.initSource!.coverUrl != null) {
        coverUploadImage.coverUrl = widget.initSource!.coverUrl;
        coverUploadImage.status = UploadTaskStatus.finished;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return FutureBuilder(
      future: _futureBuilderFuture,
      builder: (BuildContext context, AsyncSnapshot snapShot) {
        if (snapShot.connectionState == ConnectionState.done) {
          return Scaffold(
            backgroundColor: colorScheme.surface,
            body: Center(
              child: Container(
                margin: const EdgeInsets.only(bottom: 5),
                width: 400,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 400,
                      child: Column(
                        children: [
                          CommonInfoCard(coverUploadImage: coverUploadImage, titleController: titleController),
                          if (_currentUrl != null)
                            Container(
                              margin: const EdgeInsets.only(bottom: 2),
                              height: 200,
                              child: CommonMediaPlayer(key: ValueKey(_currentUrl), videoUrl: _currentUrl!, play: false),
                            ),
                          CommonActionOneButton(
                            onTap: () async {
                              await addFile();
                            },
                            textColor: colorScheme.onSecondary,
                            title: userFile == null ? "点击上传" : "重新上传",
                            backgroundColor: colorScheme.secondary,
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 20),
                            child: CommonTextEditField(textEditingController: orderController, textInputType: TextInputType.number, title: "顺序"),
                          ),
                        ],
                      ),
                    ),
                    CommonActionTwoButton(
                      height: 35,
                      onLeftTap: () {
                        Navigator.of(context).pop();
                      },
                      rightTextColor: colorScheme.onPrimary,
                      backgroundRightColor: colorScheme.primary,
                      onRightTap: () async {
                        try {
                          if (titleController.text.isEmpty) throw const FormatException("标题为空");
                          if (coverUploadImage.status != UploadTaskStatus.finished) throw const FormatException("封面未上传完毕");
                          //获取fileId
                          int? fileId;
                          if (userFile != null) {
                            fileId = userFile!.fileId;
                          }
                          var s = widget.initSource;
                          if (s != null && s is Video) {
                            fileId = s.fileId;
                          }
                          if (fileId == null) throw const FormatException("文件未添加");
                          var title = titleController.text;
                          int order = 0;
                          try {
                            order = int.parse(orderController.text);
                          } on Exception catch (_) {
                            throw const FormatException("序号类型不正确");
                          }
                          await widget.onCreate(title, coverUploadImage.coverUrl, fileId, order);
                          if (context.mounted) Navigator.pop(context);
                        } on Exception catch (e) {
                          if (context.mounted) ShowSnackBar.exception(context: context, e: e, defaultValue: "出错");
                        }
                        return false;
                      },
                    )
                  ],
                ),
              ),
            ),
          );
        } else {
          // 请求未结束，显示loading
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Future<void> addFile() async {
    //其他类型直接选择文件即可（单资源类型）
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return SelectResourceDialog(
          title: "选择文件",
          fileType: FileType.video,
          onConfirm: (res) async {
            try {
              if (res is UserFolder) {
                throw const FormatException("请选择文件");
              } else if (res is UserFile) {
                //拿到文件后
                userFile = res;
                var (url, _) = await FileUrlService.genGetFileUrl(userFile!.fileId!);
                _currentUrl = url;
                setState(() {});
              }
            } on Exception catch (e) {
              ShowSnackBar.exception(context: context, e: e, defaultValue: "选择文件出错");
            } finally {
              Navigator.pop(context);
            }
          },
          onLoad: (int parentId, int page) async {
            var list = await UserFileService.getNormalFileList(parentId: parentId, pageIndex: page).timeout(const Duration(seconds: 2));
            return list;
          },
        );
      },
    );
  }
}
