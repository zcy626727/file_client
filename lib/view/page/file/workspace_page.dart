import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:file_client/util/mime_util.dart';
import 'package:file_client/view/page/preview/image_preview_page.dart';
import 'package:file_client/view/page/preview/video_preview_page.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../../common/file/constant/upload.dart';
import '../../../common/file/task/download_task.dart';
import '../../../common/file/task/multipart_upload_task.dart';
import '../../../common/list/common_item_list.dart';
import '../../../config/global.dart';
import '../../../model/common/common_resource.dart';
import '../../../model/file/user_file.dart';
import '../../../model/file/user_folder.dart';
import '../../../service/file/user_file_service.dart';
import '../../../state/download_state.dart';
import '../../../state/upload_state.dart';
import '../../component/file/file_list_tile.dart';
import '../../component/file/folder_path_list.dart';
import '../../component/file/select_folder_dialog.dart';
import '../../component/share/create_share_dialog.dart';
import '../../component/show/show_snack_bar.dart';
import '../../widget/confirm_alert_dialog.dart';
import '../../widget/input_alert_dialog.dart';
import '../link/access_share_page.dart';

class WorkspacePage extends StatefulWidget {
  const WorkspacePage({Key? key}) : super(key: key);

  @override
  State<WorkspacePage> createState() => _WorkspacePageState();
}

class _WorkspacePageState extends State<WorkspacePage> {
  //可能是文件也可能是文件夹，不能使用id，只能用索引
  int? _selectedIndex;
  late UserFolder _currentFolder;
  bool _checkMode = false;
  final List<UserFolder> _folderPath = <UserFolder>[];

  final List<CommonResource> _selectedResourceList = [];

  GlobalKey<CommonItemListState<CommonResource>> listKey = GlobalKey<CommonItemListState<CommonResource>>();

  @override
  void initState() {
    super.initState();
    _currentFolder = UserFolder.rootFolder();
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

  Widget _operaList(BuildContext pageContext) {
    var colorScheme = Theme.of(context).colorScheme;
    var uploadState = Provider.of<UploadState>(context, listen: false);
    return Container(
      padding: const EdgeInsets.only(left: 10.0, right: 5.0, top: 6.0),
      height: 45,
      child: Row(
        children: [
          //上传文件
          SizedBox(
            height: 25,
            child: ElevatedButton(
              onPressed: () async {
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                  type: FileType.any,
                );
                if (result != null) {
                  var f = result.files.single;
                  uploadState.addUploadTask(
                    MultipartUploadTask.userFile(
                      fileName: f.name,
                      srcPath: f.path,
                      userId: Global.user.id,
                      parentId: _currentFolder.id,
                      status: UploadTaskStatus.uploading,
                    ),
                  );
                }
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
                    Icons.file_upload,
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
                            var userFolder = await UserFileService.createFolder(
                              folderName: value,
                              parentId: _currentFolder.id!,
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
                var token = await showDialog<String?>(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return InputAlertDialog(
                      onConfirm: (String value) async {
                        Navigator.pop(context, value);
                      },
                      onCancel: () {
                        Navigator.of(context).pop();
                      },
                      title: "分享链接",
                      iconData: Icons.link,
                    );
                  },
                );
                //解析链接
                if (token != null) {
                  //发送请求获取share
                  try {
                    //跳转分享文件内容
                    if (pageContext.mounted) {
                      Navigator.push(
                        pageContext,
                        MaterialPageRoute(
                          builder: (context) {
                            return Scaffold(
                              backgroundColor: colorScheme.surface,
                              body: AccessSharePage(token: token),
                            );
                          },
                        ),
                      );
                    }
                  } on Exception catch (e) {
                    if (mounted) ShowSnackBar.exception(context: context, e: e, defaultValue: "解析分享链接失败");
                  }
                }
              },
              style: ButtonStyle(
                elevation: MaterialStateProperty.all(0),
                backgroundColor: MaterialStateProperty.all(
                  colorScheme.primary.withAlpha(220),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.link, size: 18, color: colorScheme.onPrimary),
                  const SizedBox(width: 5.0),
                  Text(
                    "访问分享",
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
      onTap: (userFolder) async {
        if (userFolder is UserFolder) {
          while (_folderPath.last.id != userFolder.id) {
            _folderPath.removeLast();
          }
          _currentFolder = userFolder;
          resetFileListKey();
          cancelCheck();
          setState(() {});
        }
      },
    );
  }

  Widget _fileBody(BuildContext nContext) {
    var colorScheme = Theme.of(context).colorScheme;

    return Stack(
      fit: StackFit.expand,
      alignment: AlignmentDirectional.bottomCenter,
      children: [
        CommonItemList<CommonResource>(
          key: listKey,
          onLoad: (int page) async {
            if (_currentFolder.id == null) return <CommonResource>[];
            var list = await UserFileService.getNormalFileList(parentId: _currentFolder.id!).timeout(const Duration(seconds: 2));
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
                  if (item is UserFolder) {
                    try {
                      //双击进入文件夹
                      if (item.id == _currentFolder.id) return;
                      if (item.id == null) throw const FormatException("文件夹异常，请刷新后重试");
                      _currentFolder = item;
                      _folderPath.add(item);
                      listKey = GlobalKey<CommonItemListState<CommonResource>>();
                      cancelCheck();
                      resetFileListKey();
                      setState(() {});
                    } on Exception catch (e) {
                      if (context.mounted) ShowSnackBar.exception(context: context, e: e);
                    }
                  } else if (item is UserFile) {
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
                          if (_selectedResourceList.isEmpty) {
                            return;
                          }
                          try {
                            List<int> userFileIdList = [];
                            for (var res in _selectedResourceList) {
                              if (res.id != null) {
                                userFileIdList.add(res.id!);
                              }
                            }
                            if (userFileIdList.isEmpty) throw const FormatException("未选择文件");
                            await createShare(userFileIdList, "批量分享");
                            cancelCheck();
                            setState(() {});
                            if (mounted) ShowSnackBar.info(context: context, message: "分享成功");
                          } on DioException catch (e) {
                            if (mounted) ShowSnackBar.exception(context: context, e: e, defaultValue: "分享失败");
                          }
                        },
                        icon: Icon(
                          Icons.share,
                          color: colorScheme.onPrimaryContainer,
                          size: 19,
                        ),
                      ),
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
                                      List<int> userFileIdList = <int>[];

                                      for (var res in _selectedResourceList) {
                                        if (res.id != null) {
                                          userFileIdList.add(res.id!);
                                        }
                                      }
                                      await UserFileService.deleteFileList(userFileIdList: userFileIdList);
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
                              });
                        },
                        icon: Icon(
                          Icons.delete,
                          color: colorScheme.onPrimaryContainer,
                          size: 20,
                        ),
                      ),
                      // IconButton(
                      //   splashRadius: 18,
                      //   onPressed: () {},
                      //   icon: Icon(
                      //     Icons.download_for_offline,
                      //     color: colorScheme.onPrimaryContainer,
                      //     size: 20,
                      //   ),
                      // ),
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
              ))
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
        globalPosition.dx - 240,
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
          value: 'share',
          child: Text(
            '分享',
            style: TextStyle(color: colorScheme.onBackground.withAlpha(200), fontSize: 14),
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
        if (res is UserFile)
          PopupMenuItem(
            height: 35,
            value: 'download',
            child: Text(
              '下载',
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
          case "share":
            List<int> userFileIdList = [];
            if (res.id != null) {
              userFileIdList.add(res.id!);
            }
            await createShare(userFileIdList, res.name!);
            cancelCheck();
            setState(() {});
            break;
          case "download":
            if (res is UserFile) {
              var directory = await getDownloadsDirectory();
              if (directory != null) {
                if (context.mounted) {
                  var downloadState = Provider.of<DownloadState>(context, listen: false);
                  downloadState.addDownloadTask(DownloadTask.all(
                    userId: Global.user.id,
                    userFileId: res.id,
                    targetPath: directory.path,
                    targetName: res.name,
                    totalSize: res.fileSize,
                    createTime: DateTime.now(),
                  ));
                }
              }
            }
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
                await UserFileService.renameFile(userFileId: res.id!, newFilename: value);
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

  Future<void> createShare(List<int> userFileIdList, String shareName) async {
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return CreateShareDialog(
          userFileIdList: userFileIdList,
          shareName: shareName,
        );
      },
    );
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
              await UserFileService.deleteFile(userFileId: selectedRes.id!);
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
        return SelectFolderDialog(
          filterIdSet: selectedRes.id != null ? <int>{selectedRes.id!} : null,
          title: "移动到",
          onConfirm: (targetFolder) async {
            try {
              //移动文件或文件夹
              if (selectedRes.parentId == targetFolder.id) throw const FormatException("文件夹已存在于该路径");
              if (selectedRes.id == null || selectedRes.parentId == null) throw const FormatException("文件夹信息错误，刷新后再试");

              await UserFileService.moveFile(fileId: selectedRes.id!, newParentId: targetFolder.id!, keepUnique: true);
              listKey.currentState?.removeItem(selectedRes);
              setState(() {});
            } on Exception catch (e) {
              if (context.mounted) ShowSnackBar.exception(context: context, e: e, defaultValue: "移动文件出错");
            } finally {
              if (context.mounted) Navigator.pop(context);
            }
          },
        );
      },
    );
  }

  void moveResourceList() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return SelectFolderDialog(
          title: "移动到",
          onConfirm: (targetFolder) async {
            try {
              if (_currentFolder.id == targetFolder.id) throw const FormatException("文件夹已存在于该路径");

              List<int> userFileIdList = <int>[];

              for (var res in _selectedResourceList) {
                if (res.id != null) {
                  userFileIdList.add(res.id!);
                }
              }
              if (userFileIdList.isEmpty) throw const FormatException("选择文件为空");
              if (targetFolder.id == null) throw const FormatException("获取目标文件夹失败");
              await UserFileService.moveFileList(userFileIdList: userFileIdList, newParentId: targetFolder.id!, keepUnique: true);
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
        );
      },
    );
  }

  void cancelCheck() {
    _selectedResourceList.clear();
    _checkMode = false;
  }

  void resetFileListKey() {
    listKey = GlobalKey<CommonItemListState<CommonResource>>();
  }
}
