import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:file_client/service/file/bulk_service.dart';
import 'package:file_client/util/mime_util.dart';
import 'package:file_client/view/page/preview/image_preview_page.dart';
import 'package:file_client/view/page/preview/video_preview_page.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../../config/global.dart';
import '../../../constant/resource.dart';
import '../../../domain/task/download_task.dart';
import '../../../domain/task/enum/upload.dart';
import '../../../domain/task/multipart_upload_task.dart';
import '../../../domain/upload_notion.dart';
import '../../../model/common/common_resource.dart';
import '../../../model/file/user_file.dart';
import '../../../model/file/user_folder.dart';
import '../../../service/file/resource_service.dart';
import '../../../service/file/share_service.dart';
import '../../../service/file/user_file_service.dart';
import '../../../service/file/user_folder_service.dart';
import '../../../state/download_state.dart';
import '../../../state/path_state.dart';
import '../../../state/upload_state.dart';
import '../../component/file/file_list_tile.dart';
import '../../component/file/folder_path_list.dart';
import '../../component/file/select_folder_dialog.dart';
import '../../component/share/create_share_dialog.dart';
import '../../component/show/show_snack_bar.dart';
import '../../widget/confirm_alert_dialog.dart';
import '../../widget/input_alert_dialog.dart';
import '../link/share_context_page.dart';

class WorkspacePage extends StatefulWidget {
  const WorkspacePage({Key? key}) : super(key: key);

  @override
  State<WorkspacePage> createState() => _WorkspacePageState();
}

class _WorkspacePageState extends State<WorkspacePage> {
  //可能是文件也可能是文件夹，不能使用id，只能用索引
  int _selectedIndex = -1;
  late UserFolder _currentFolder;
  late Future _futureBuilderFuture;
  bool _loadingResourceList = false;
  bool _checkMode = false;

  final List<CommonResource> _selectedResourceList = [];

  List<CommonResource> _resourceList = <CommonResource>[];

  Future<void> loadFileAndFolderList(int parentId) async {
    try {
      _resourceList =
          await ResourceService.getFileAndFolderList(parentId: parentId, statusList: <int>[ResourceStatus.normal.index, ResourceStatus.uploading.index]).timeout(const Duration(seconds: 2));
    } on DioException catch (e) {
      log(e.toString());
    } catch (e) {
      log(e.toString());
    }
  }

  Future getData() async {
    var folderList = Provider.of<PathState>(context, listen: false).mainPathList;
    var folderId = 0;
    if (folderList.isNotEmpty) {
      folderId = folderList.last.id!;
      _currentFolder = folderList.last;
    } else {
      //根目录
      _currentFolder = UserFolder.rootFolder();
    }
    return Future.wait([loadFileAndFolderList(folderId)]);
  }

  @override
  void initState() {
    _futureBuilderFuture = getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _futureBuilderFuture,
      builder: (BuildContext context, AsyncSnapshot snapShot) {
        if (snapShot.connectionState == ConnectionState.done) {
          return Navigator(
            onGenerateRoute: (val) {
              return PageRouteBuilder(
                pageBuilder: (BuildContext nContext, Animation<double> animation, Animation<double> secondaryAnimation) {
                  return Column(
                    children: [
                      _operaList(nContext),
                      _buildPathList(),
                      Expanded(
                        child: _fileBody(),
                      ),
                    ],
                  );
                },
              );
            },
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
                    MultipartUploadTask.file(
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
                            var userFolder = await UserFolderService.createFolder(
                              _currentFolder.id!,
                              value,
                            );
                            _resourceList.add(userFolder);
                            setState(() {});
                            if (mounted) Navigator.of(context).pop();
                          } on Exception catch (e) {
                            ShowSnackBar.exception(context: context, e: e, defaultValue: "新建文件夹失败");
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
                  SizedBox(width: 5.0),
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
                var value = await showDialog<String?>(
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
                var token = value;
                if (token != null) {
                  //发送请求获取share
                  try {
                    var share = await ShareService.getShareByToken(token);
                    //跳转分享文件内容
                    if (mounted) {
                      Navigator.push(
                        pageContext,
                        MaterialPageRoute(
                          builder: (context) {
                            return Scaffold(
                              backgroundColor: colorScheme.surface,
                              body: ShareContextPage(share: share),
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
                  SizedBox(width: 5.0),
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
    var folderPath = Provider.of<PathState>(context, listen: true);
    var folderList = folderPath.mainPathList;
    return FolderPathList(
      margin: const EdgeInsets.only(left: 13.0, top: 1.0),
      folderList: folderList,
      onTap: (userFolder) async {
        if (userFolder is UserFolder) {
          if (userFolder.id == 0) {
            //根目录
            folderPath.clearMainPath();
          } else {
            folderPath.turnToMainFolder(userFolder);
          }
          await loadFileAndFolderList(userFolder.id!);
          _currentFolder = userFolder;
          _loadingResourceList = false;

          cancelCheck();
          setState(() {});
        }
      },
    );
  }

  Widget _fileBody() {
    var colorScheme = Theme.of(context).colorScheme;

    //监控通知，如果发生上传任务的创建或完成时需要做对resourceList做对应的操作
    var pathState = Provider.of<PathState>(context, listen: false);

    return Stack(
      fit: StackFit.expand,
      alignment: AlignmentDirectional.bottomCenter,
      children: [
        _loadingResourceList
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Selector<UploadState, List<UploadNotion>>(
                selector: (context, uploadState) => uploadState.uploadNotionList,
                shouldRebuild: (pre, next) => next.isNotEmpty,
                builder: (context, uploadNotionList, child) {
                  while (uploadNotionList.isNotEmpty) {
                    var notion = uploadNotionList.removeAt(0);
                    switch (notion.type) {
                      case UploadNotionType.createUpload:
                        _resourceList.insert(0, notion.userFile);
                        break;
                      case UploadNotionType.completeUpload:
                        for (var res in _resourceList) {
                          if (res.id == notion.userFile.id) {
                            res.status = ResourceStatus.normal.index;
                            break;
                          }
                        }
                        break;
                    }
                  }
                  return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 160, childAspectRatio: 0.9),
                    itemBuilder: (ctx, idx) {
                      var res = _resourceList[idx];
                      return Container(
                        key: ValueKey("${res.id}-$_checkMode"),
                        margin: const EdgeInsets.all(2.0),
                        child: ResourceListItem(
                          onPreTap: () async {
                            setState(() {
                              _selectedIndex = idx;
                            });
                          },
                          onTap: () {
                            log("单击");
                          },
                          onSecondaryTap: (TapDownDetails details) {
                            setState(() {
                              _selectedIndex = idx;
                            });
                            moreOpera(context, details, res);
                          },
                          onDoubleTap: () async {
                            //是文件夹
                            if (res is UserFolder) {
                              //双击进入文件夹
                              if (res.id != null) {
                                _resourceList = await ResourceService.getFileAndFolderList(parentId: res.id!, statusList: <int>[ResourceStatus.normal.index, ResourceStatus.uploading.index]);
                                pathState.addMainFolder(res);
                                _currentFolder = res;
                              }
                              cancelCheck();
                            } else if (res is UserFile) {
                              var mimeType = lookupMimeType(res.name ?? "");
                              if (mimeType != null) {
                                if (MimeUtil.isMedia(mimeType)) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return VideoPreviewPage(fileId: res.fileId!);
                                      },
                                    ),
                                  );
                                } else if (MimeUtil.isImage(mimeType)) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return ImagePreviewPage(fileId: res.fileId!);
                                      },
                                    ),
                                  );
                                }
                              }
                            }
                            _loadingResourceList = false;

                            setState(() {});
                          },
                          onCheck: (b) {
                            if (b) {
                              _selectedResourceList.add(res);
                            } else {
                              _selectedResourceList.remove(res);
                            }
                          },
                          isCheckMode: _checkMode,
                          resource: res,
                          selected: _selectedIndex == idx,
                        ),
                      );
                    },
                    itemCount: _resourceList.length,
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
                            List<UserFile> userFileList = [];
                            List<UserFolder> userFolderList = [];
                            for (var res in _selectedResourceList) {
                              if (res is UserFile) {
                                userFileList.add(res);
                              } else if (res is UserFolder) {
                                userFolderList.add(res);
                              }
                            }
                            await createShare(userFileList, userFolderList, "批量分享");
                            cancelCheck();
                            setState(() {});
                            if (mounted) ShowSnackBar.info(context: context, message: "分享成功");
                          } on DioException catch (e) {
                            ShowSnackBar.exception(context: context, e: e, defaultValue: "分享失败");
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
                                      List<int> userFolderIdList = <int>[];

                                      for (var res in _selectedResourceList) {
                                        if (res is UserFile) {
                                          if (res.id != null) {
                                            userFileIdList.add(res.id!);
                                          }
                                        } else if (res is UserFolder) {
                                          if (res.id != null) {
                                            userFolderIdList.add(res.id!);
                                          }
                                        }
                                      }

                                      await BulkService.deleteResourceList(userFileIdList: userFileIdList, userFolderIdList: userFolderIdList);
                                      for (var res in _selectedResourceList) {
                                        _resourceList.remove(res);
                                      }
                                      cancelCheck();
                                      setState(() {});
                                    } on DioException catch (e) {
                                      ShowSnackBar.exception(context: context, e: e, defaultValue: "删除失败");
                                    } finally {
                                      Navigator.pop(context);
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
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  //是文件夹
                  return InputAlertDialog(
                    initValue: res.name!,
                    onConfirm: (value) async {
                      try {
                        if (res is UserFolder) {
                          await UserFolderService.renameFolder(
                            folderId: res.id!,
                            newFolderName: value,
                            oldFolderName: res.name!,
                          );
                        } else {
                          await UserFileService.renameFile(
                            folderId: res.id!,
                            newFolderName: value,
                            oldFolderName: res.name!,
                          );
                        }
                        setState(() {
                          res.name = value;
                        });
                      } on DioException catch (e) {
                        ShowSnackBar.exception(context: context, e: e, defaultValue: "重命名失败");
                      } finally {
                        Navigator.pop(context);
                      }
                    },
                    onCancel: () {
                      Navigator.pop(context);
                    },
                    title: "重命名",
                    iconData: res is UserFile ? Icons.insert_drive_file : Icons.folder,
                  );
                });
            break;
          case "move":
            moveFileOrFolder(res);
            break;
          case "delete":
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return ConfirmAlertDialog(
                    text: "是否确定删除？",
                    onConfirm: () async {
                      try {
                        if (res is UserFolder) {
                          await UserFolderService.deleteFolder(res.id!);
                        } else {
                          await UserFileService.deleteFile(res.id!);
                        }
                        setState(() {
                          _resourceList.remove(res);
                        });
                      } on DioException catch (e) {
                        ShowSnackBar.exception(context: context, e: e, defaultValue: "删除失败");
                      } finally {
                        Navigator.pop(context);
                      }
                    },
                    onCancel: () {
                      Navigator.pop(context);
                    },
                  );
                });
            break;
          case "share":
            List<UserFile> userFileList = [];
            List<UserFolder> userFolderList = [];
            if (res is UserFile) {
              userFileList.add(res);
            } else if (res is UserFolder) {
              userFolderList.add(res);
            }
            await createShare(userFileList, userFolderList, res.name!);
            cancelCheck();
            setState(() {});
            break;
          case "download":
            if (res is UserFile) {
              var directory = await getDownloadsDirectory();
              if (directory != null) {
                if (mounted) {
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

  Future<void> createShare(List<UserFile> userFileList, List<UserFolder> userFolderList, String shareName) async {
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return CreateShareDialog(
          userFileList: userFileList,
          userFolderList: userFolderList,
          shareName: shareName,
        );
      },
    );
  }

  void moveFileOrFolder(CommonResource selectedRes) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return SelectFolderDialog(
          title: "移动到",
          onConfirm: (targetFolder) async {
            try {
              //移动文件或文件夹
              if (selectedRes is UserFolder) {
                if (selectedRes.parentId == targetFolder.id) {
                  throw const FormatException("文件夹已存在于该路径");
                }
                await UserFolderService.moveFolder(folderId: selectedRes.id!, oldParentId: selectedRes.parentId!, newParentId: targetFolder.id!);
              } else if (selectedRes is UserFile) {
                if (selectedRes.parentId == targetFolder.id) {
                  throw const FormatException("文件已存在于该路径");
                }
                await UserFileService.moveFile(fileId: selectedRes.id!, oldParentId: selectedRes.parentId!, newParentId: targetFolder.id!);
              }
              _resourceList.remove(selectedRes);
              setState(() {});
            } on Exception catch (e) {
              ShowSnackBar.exception(context: context, e: e, defaultValue: "移动文件出错");
            } finally {
              Navigator.pop(context);
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
              if (_currentFolder.id == targetFolder.id) {
                throw const FormatException("文件夹已存在于该路径");
              }

              List<int> userFileIdList = <int>[];
              List<int> userFolderIdList = <int>[];

              for (var res in _selectedResourceList) {
                if (res is UserFile) {
                  if (res.id != null) {
                    userFileIdList.add(res.id!);
                  }
                } else if (res is UserFolder) {
                  if (res.id != null) {
                    userFolderIdList.add(res.id!);
                  }
                }
              }
              await BulkService.moveResourceList(oldParentId: _currentFolder.id!, newParentId: targetFolder.id!, userFileIdList: userFileIdList, userFolderIdList: userFolderIdList);
              for (var res in _selectedResourceList) {
                _resourceList.remove(res);
              }
              cancelCheck();
              setState(() {});
            } on Exception catch (e) {
              ShowSnackBar.exception(context: context, e: e, defaultValue: "移动文件出错");
            } finally {
              Navigator.pop(context);
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
}
