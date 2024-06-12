import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:file_client/model/space/space.dart';
import 'package:file_client/model/space/space_folder.dart';
import 'package:file_client/view/component/file/select_resource_dialog.dart';
import 'package:file_client/view/component/resource/resource_detail_dialog.dart';
import 'package:file_picker/file_picker.dart' as file_picker;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/file/constant/upload.dart';
import '../../../common/file/task/multipart_upload_task.dart';
import '../../../common/list/common_item_list.dart';
import '../../../constant/file.dart';
import '../../../model/common/common_resource.dart';
import '../../../model/file/user_file.dart';
import '../../../model/file/user_folder.dart';
import '../../../model/space/space_file.dart';
import '../../../service/team/space_file_service.dart';
import '../../../state/upload_state.dart';
import '../../../util/mime_util.dart';
import '../../component/file/file_list_tile.dart';
import '../../component/file/folder_path_list.dart';
import '../../component/file/select_user_file_dialog.dart';
import '../../component/show/show_snack_bar.dart';
import '../../widget/confirm_alert_dialog.dart';
import '../../widget/input_alert_dialog.dart';
import '../preview/image_preview_page.dart';
import '../preview/video_preview_page.dart';

class SpaceWorkspacePage extends StatefulWidget {
  const SpaceWorkspacePage({super.key, required this.space});

  final Space space;

  @override
  State<SpaceWorkspacePage> createState() => _SpaceWorkspacePageState();
}

class _SpaceWorkspacePageState extends State<SpaceWorkspacePage> {
  //可能是文件也可能是文件夹，不能使用id，只能用索引
  int? _selectedIndex = -1;
  late SpaceFolder _currentFolder;
  bool _checkMode = false;

  final List<SpaceFolder> _folderPath = <SpaceFolder>[];

  final List<CommonResource> _selectedResourceList = [];

  GlobalKey<CommonItemListState<CommonResource>> listKey = GlobalKey<CommonItemListState<CommonResource>>();

  @override
  void initState() {
    super.initState();
    _currentFolder = SpaceFolder.rootFolder(spaceId: widget.space.id!);
    _folderPath.add(_currentFolder);
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (val) {
        return PageRouteBuilder(
          pageBuilder: (BuildContext nContext, Animation<double> animation, Animation<double> secondaryAnimation) {
            return Column(
              children: [
                _operaList(nContext),
                _buildPathList(),
                Expanded(
                  child: _fileBody(nContext),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // 首行操作按钮
  Widget _operaList(BuildContext pageContext) {
    var colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.only(left: 10.0, right: 5.0, top: 6.0),
      height: 45,
      child: Row(
        children: [
          //上传文件
          SizedBox(
            height: 25,
            child: ElevatedButton(
              onPressed: () {
                // 选择从哪里获取文件
                showDialog(
                  barrierDismissible: true,
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      contentPadding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10),
                      backgroundColor: colorScheme.surface,
                      titlePadding: const EdgeInsets.only(top: 15.0, left: 10.0, bottom: 10),
                      title: Text("选择文件", style: TextStyle(color: colorScheme.onSurface)),
                      content: SizedBox(
                        height: 110,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              width: double.infinity,
                              height: 40,
                              child: OutlinedButton(
                                onPressed: () async {
                                  await addFileFromWorkspace();
                                  if (context.mounted) Navigator.pop(context);
                                },
                                child: const Text("个人空间"),
                              ),
                            ),
                            SizedBox(
                              height: 40,
                              width: double.infinity,
                              child: OutlinedButton(
                                onPressed: () async {
                                  await addFileFromLocal();
                                  if (context.mounted) Navigator.pop(context);
                                },
                                child: const Text("本地存储"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              style: ButtonStyle(
                elevation: MaterialStateProperty.all(0),
                backgroundColor: MaterialStateProperty.all(
                  colorScheme.primary.withAlpha(220),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.upload,
                    size: 18,
                    color: colorScheme.onPrimary,
                  ),
                  const SizedBox(width: 5.0),
                  Text(
                    "上传文件",
                    style: TextStyle(color: colorScheme.onPrimary),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(width: 5),
          SizedBox(
            height: 25,
            child: ElevatedButton(
              onPressed: () async {
                await showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return InputAlertDialog(
                      onConfirm: (String value) async {
                        if (value.isNotEmpty) {
                          try {
                            if (widget.space.id == null) throw const FormatException("空间信息异常");
                            var userFolder = await SpaceFileService.createFolder(
                              folderName: value,
                              parentId: _currentFolder.id!,
                              spaceId: widget.space.id!,
                            );
                            listKey.currentState?.addItem(userFolder);
                            listKey.currentState?.setState(() {});
                            if (context.mounted) Navigator.of(context).pop();
                            setState(() {});
                          } on Exception catch (e) {
                            if (context.mounted) ShowSnackBar.exception(context: context, e: e, defaultValue: "新建文件夹失败");
                          }
                        }
                      },
                      onCancel: () {
                        Navigator.of(context).pop();
                      },
                      title: "新建文件夹",
                      iconData: Icons.folder,
                    );
                  },
                );
              },
              style: ButtonStyle(
                elevation: MaterialStateProperty.all(0),
                backgroundColor: MaterialStateProperty.all(
                  colorScheme.primary.withAlpha(220),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.create_new_folder,
                    size: 18,
                    color: colorScheme.onPrimary,
                  ),
                  const SizedBox(width: 5.0),
                  Text(
                    "新建文件夹",
                    style: TextStyle(color: colorScheme.onPrimary),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 5),
          SizedBox(
            height: 25,
            child: ElevatedButton(
              onPressed: () async {
                _checkMode = !_checkMode;
                _selectedResourceList.clear();
                setState(() {});
              },
              style: ButtonStyle(
                elevation: MaterialStateProperty.all(0),
                backgroundColor: MaterialStateProperty.all(
                  colorScheme.primary.withAlpha(220),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.view_module,
                    size: 18,
                    color: colorScheme.onPrimary,
                  ),
                  const SizedBox(width: 5.0),
                  Text(
                    _checkMode ? "取消批量操作" : "批量操作",
                    style: TextStyle(color: colorScheme.onPrimary),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPathList() {
    return FolderPathList(
      margin: const EdgeInsets.only(left: 13.0, top: 1.0),
      folderList: _folderPath,
      onTap: (spaceFolder) async {
        if (spaceFolder is SpaceFolder) {
          while (_folderPath.last.id != spaceFolder.id) {
            _folderPath.removeLast();
          }
          _currentFolder = spaceFolder;
          resetFileListKey();
          cancelCheck();
          setState(() {});
        }
      },
    );
  }

  // 文件列表
  Widget _fileBody(BuildContext nContext) {
    var colorScheme = Theme.of(context).colorScheme;
    return Stack(
      fit: StackFit.expand,
      alignment: AlignmentDirectional.bottomCenter,
      children: [
        CommonItemList<CommonResource>(
          key: listKey,
          onLoad: (int page) async {
            if (widget.space.id == null) return <CommonResource>[];
            var list = await SpaceFileService.getNormalFileList(parentId: _currentFolder.id ?? 0, spaceId: widget.space.id!, pageIndex: page);
            return list;
          },
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 160, childAspectRatio: 0.9),
          itemName: "文件",
          itemHeight: null,
          isGrip: true,
          enableScrollbar: true,
          itemBuilder: (ctx, item, itemList, onFresh) {
            return Container(
              key: ValueKey(item.id),
              margin: const EdgeInsets.all(2.0),
              child: ResourceListItem(
                onPreTap: () async {
                  setState(() {
                    _selectedIndex = item.id;
                  });
                },
                onTap: () {
                  log("单击");
                },
                onSecondaryTap: (TapDownDetails details) {
                  setState(() {
                    _selectedIndex = item.id;
                  });
                  moreOpera(context, details, item);
                },
                onDoubleTap: () async {
                  //是文件夹
                  if (item is SpaceFolder) {
                    if (item.id != null) {
                      //双击进入文件夹
                      if (item.id == _currentFolder.id) return;
                      if (item.id == null) throw const FormatException("文件夹异常，请刷新后重试");
                      _currentFolder = item;
                      _folderPath.add(item);
                      cancelCheck();
                      resetFileListKey();
                      setState(() {});
                    }
                  } else if (item is SpaceFile) {
                    //预览文件
                    var mimeType = item.mimeType;
                    if (mimeType != null) {
                      if (MimeUtil.isMedia(mimeType)) {
                        Navigator.push(
                          nContext,
                          MaterialPageRoute(
                            builder: (context) {
                              return VideoPreviewPage(fileId: item.fileId!);
                            },
                          ),
                        );
                      } else if (MimeUtil.isImage(mimeType)) {
                        Navigator.push(
                          nContext,
                          MaterialPageRoute(
                            builder: (context) {
                              return ImagePreviewPage(fileId: item.fileId!);
                            },
                          ),
                        );
                      }
                    }
                  }
                  setState(() {});
                },
                onCheck: (b) {
                  if (b) {
                    _selectedResourceList.add(item);
                  } else {
                    _selectedResourceList.remove(item);
                  }
                },
                isCheckMode: _checkMode,
                resource: item,
                selected: _selectedIndex != null && _selectedIndex == item.id,
              ),
            );
          },
        ),
        // 批量操作
        if (_checkMode)
          Positioned(
            bottom: 10,
            child: Material(
              color: colorScheme.primaryContainer,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    IconButton(
                      splashRadius: 18,
                      onPressed: () async {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return ConfirmAlertDialog(
                              text: "是否确定删除？",
                              onConfirm: () async {
                                try {
                                  if (_selectedResourceList.isEmpty) {
                                    return;
                                  }
                                  List<int> spaceFileIdList = <int>[];

                                  for (var res in _selectedResourceList) {
                                    if (res.id != null) {
                                      spaceFileIdList.add(res.id!);
                                    }
                                  }
                                  await SpaceFileService.deleteFileList(spaceFileIdList: spaceFileIdList);
                                  for (var res in _selectedResourceList) {
                                    listKey.currentState?.removeItem(res);
                                  }
                                  cancelCheck();
                                  setState(() {});
                                } on DioException catch (e) {
                                  if (context.mounted) ShowSnackBar.exception(context: context, e: e, defaultValue: "删除失败");
                                } finally {
                                  if (context.mounted) Navigator.pop(context);
                                }
                              },
                              onCancel: () {
                                Navigator.pop(context);
                              },
                            );
                          },
                        );
                      },
                      icon: Icon(
                        Icons.delete,
                        color: colorScheme.onPrimaryContainer,
                        size: 20,
                      ),
                    ),
                    IconButton(
                      splashRadius: 18,
                      onPressed: () {
                        if (_selectedResourceList.isEmpty) {
                          return;
                        }
                        moveResourceList();
                      },
                      icon: Icon(
                        Icons.drive_file_move,
                        color: colorScheme.onPrimaryContainer,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  void moreOpera(BuildContext context, TapDownDetails details, CommonResource res) {
    var globalPosition = details.globalPosition;
    var colorScheme = Theme.of(context).colorScheme;
    showMenu(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          width: 1,
          color: colorScheme.onSurface.withAlpha(30),
          style: BorderStyle.solid,
        ),
      ),
      color: colorScheme.surface,
      context: context,
      position: RelativeRect.fromLTRB(
        globalPosition.dx - 180,
        globalPosition.dy,
        globalPosition.dx,
        globalPosition.dy,
      ),
      items: [
        PopupMenuItem(
          height: 35,
          value: 'rename',
          child: Text(
            '重命名',
            style: TextStyle(color: colorScheme.onSurface.withAlpha(200), fontSize: 14),
          ),
        ),
        PopupMenuItem(
          height: 35,
          value: 'move',
          child: Text(
            '移动',
            style: TextStyle(color: colorScheme.onBackground.withAlpha(200), fontSize: 14),
          ),
        ),
        PopupMenuItem(
          height: 35,
          value: 'delete',
          child: Text(
            '删除',
            style: TextStyle(color: colorScheme.onBackground.withAlpha(200), fontSize: 14),
          ),
        ),
        if (res is SpaceFile)
          PopupMenuItem(
            height: 35,
            value: 'download',
            child: Text(
              '下载',
              style: TextStyle(color: colorScheme.onBackground.withAlpha(200), fontSize: 14),
            ),
          ),
        PopupMenuItem(
          height: 35,
          value: 'detail',
          child: Text(
            '详情',
            style: TextStyle(color: colorScheme.onBackground.withAlpha(200), fontSize: 14),
          ),
        ),
      ],
    ).then(
      (value) async {
        switch (value) {
          case "rename": //重命名
            renameFile(res);
            break;
          case "move":
            moveFile(res);
            break;
          case "delete":
            deleteFile(res);
            break;
          case "download":
            break;
          case "detail":
            await showDialog(
              context: context,
              barrierDismissible: true,
              builder: (BuildContext context) {
                return ResourceDetailDialog(resource: res, space: widget.space);
              },
            );
            break;
        }
      },
    );
  }

  void renameFile(CommonResource res) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          //是文件夹
          return InputAlertDialog(
            initValue: res.name!,
            onConfirm: (value) async {
              try {
                if (res.id == null) throw const FormatException("重命名失败");
                await SpaceFileService.renameFile(spaceFileId: res.id!, newName: value);
                setState(() {
                  res.name = value;
                });
              } on DioException catch (e) {
                if (context.mounted) ShowSnackBar.exception(context: context, e: e, defaultValue: "重命名失败");
              } finally {
                if (context.mounted) Navigator.pop(context);
              }
            },
            onCancel: () {
              Navigator.pop(context);
            },
            title: "重命名",
            iconData: res is UserFile ? Icons.insert_drive_file : Icons.folder,
          );
        });
  }

  void deleteFile(CommonResource selectedRes) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmAlertDialog(
          text: "是否确定删除？",
          onConfirm: () async {
            try {
              if (selectedRes.id == null) throw const FormatException("删除失败");
              await SpaceFileService.deleteFile(spaceFileId: selectedRes.id!);
              setState(() {
                listKey.currentState?.removeItem(selectedRes);
              });
            } on DioException catch (e) {
              if (context.mounted) ShowSnackBar.exception(context: context, e: e, defaultValue: "删除失败");
            } finally {
              if (context.mounted) Navigator.pop(context);
            }
          },
          onCancel: () {
            Navigator.pop(context);
          },
        );
      },
    );
  }

  void moveFile(CommonResource selectedRes) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return SelectResourceDialog(
          title: "移动到",
          onConfirm: (targetFolder) async {
            try {
              if (_currentFolder.id == targetFolder?.id) throw const FormatException("文件夹已存在于该路径");
              List<int> userFileIdList = <int>[];

              for (var res in _selectedResourceList) {
                if (res.id != null) {
                  userFileIdList.add(res.id!);
                }
              }

              if (targetFolder?.id == null) throw const FormatException("获取目标文件夹失败");

              await SpaceFileService.moveFileList(spaceFileIdList: userFileIdList, newParentId: targetFolder!.id!);
              for (var res in _selectedResourceList) {
                listKey.currentState?.removeItem(res);
              }
              cancelCheck();
              setState(() {});
            } on Exception catch (e) {
              if (context.mounted) ShowSnackBar.exception(context: context, e: e, defaultValue: "移动文件出错");
            } finally {
              if (context.mounted) Navigator.pop(context);
            }
          },
          onLoad: (int parentId) async {
            if (widget.space.id == null) return <CommonResource>[];
            var list = await SpaceFileService.getNormalFolderList(parentId: parentId, spaceId: widget.space.id!);
            return list;
          },
        );
      },
    );
  }

  void cancelCheck() {
    _selectedResourceList.clear();
    _checkMode = false;
  }

  void moveResourceList() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Container();
      },
    );
  }

  //选择个人文件后添加
  Future<void> addFileFromWorkspace() async {
    //其他类型直接选择文件即可（单资源类型）
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return SelectUserFileDialog(
          title: "选择文件",
          fileType: FileType.any,
          onConfirm: (res) async {
            try {
              if (res is UserFolder) {
                throw const FormatException("请选择文件");
              } else if (res is UserFile) {
                if (res.name == null || res.fileId == null || _currentFolder.id == null) throw const FormatException("所选文件状态异常");
                if (widget.space.id == null) throw const FormatException("空间状态异常");
                //拿到文件后保存到本地目录
                var spaceFile = await SpaceFileService.createFile(filename: res.name!, fileId: res.fileId!, parentId: _currentFolder.id!, spaceId: widget.space.id!);
                listKey.currentState?.addItem(spaceFile);
                listKey.currentState?.setState(() {});
              }
            } on Exception catch (e) {
              if (context.mounted) ShowSnackBar.exception(context: context, e: e, defaultValue: "选择文件出错");
            } finally {
              if (context.mounted) Navigator.pop(context);
            }
          },
        );
      },
    );
  }

  Future<void> addFileFromLocal() async {
    var uploadState = Provider.of<UploadState>(context, listen: false);

    var result = await file_picker.FilePicker.platform.pickFiles(
      type: file_picker.FileType.any,
    );
    if (result != null) {
      var f = result.files.single;
      uploadState.addUploadTask(
        MultipartUploadTask.spaceFile(
          fileName: f.name,
          srcPath: f.path,
          spaceId: widget.space.id,
          parentId: _currentFolder.id,
          status: UploadTaskStatus.uploading,
        ),
      );
    }
  }

  void resetFileListKey() {
    listKey = GlobalKey<CommonItemListState<CommonResource>>();
  }
}
