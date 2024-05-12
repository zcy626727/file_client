import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:file_client/model/space/space_folder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/common/common_resource.dart';
import '../../../model/file/user_file.dart';
import '../../../model/space/space_file.dart';
import '../../../state/path_state.dart';
import '../../component/file/file_list_tile.dart';
import '../../component/file/folder_path_list.dart';
import '../../component/file/select_folder_dialog.dart';
import '../../component/show/show_snack_bar.dart';
import '../../widget/confirm_alert_dialog.dart';
import '../../widget/input_alert_dialog.dart';

class SpaceWorkspacePage extends StatefulWidget {
  const SpaceWorkspacePage({super.key, required this.spaceId});

  final int spaceId;

  @override
  State<SpaceWorkspacePage> createState() => _SpaceWorkspacePageState();
}

class _SpaceWorkspacePageState extends State<SpaceWorkspacePage> {
  //可能是文件也可能是文件夹，不能使用id，只能用索引
  int _selectedIndex = -1;
  late SpaceFolder _currentFolder;
  late Future _futureBuilderFuture;
  bool _loadingResourceList = false;
  bool _checkMode = false;
  List<SpaceFolder> folderList = <SpaceFolder>[];

  final List<CommonResource> _selectedResourceList = [];

  List<CommonResource> _resourceList = <CommonResource>[SpaceFolder.testFolder(), SpaceFolder.testFolder(), SpaceFolder.testFolder(), SpaceFile.testFile(), SpaceFile.testFile()];

  Future<void> loadFileAndFolderList() async {
    try {
      //获取当前文件夹的文件和文件夹
      // _resourceList = await ResourceService.getFileAndFolderList(parentId: parentId, statusList: <int>[ResourceStatus.normal.index, ResourceStatus.uploading.index]).timeout(Duration(seconds: 2));
    } on DioException catch (e) {
      log(e.toString());
    } catch (e) {
      log(e.toString());
    }
  }

  Future getData() async {
    return Future.wait([loadFileAndFolderList()]);
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
              onPressed: () async {},
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
                  SizedBox(width: 5.0),
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
    var folderList = folderPath.getSpaceFolder(spaceId: widget.spaceId);
    return FolderPathList(
      margin: const EdgeInsets.only(left: 13.0, top: 1.0),
      folderList: folderList,
      onTap: (spaceFolder) async {
        if (spaceFolder is SpaceFolder) {
          if (spaceFolder.id == 0) {
            //根目录
            // folderPath.clearMainPath();
          } else {
            // folderPath.turnToMainFolder(spaceFolder);
          }
          // await loadFileAndFolderList(spaceFolder.id!);
          _currentFolder = spaceFolder;
          _loadingResourceList = false;

          cancelCheck();
          setState(() {});
        }
      },
    );
  }

  // 文件/文件夹列表
  Widget _fileBody() {
    var colorScheme = Theme.of(context).colorScheme;
    return Stack(
      fit: StackFit.expand,
      alignment: AlignmentDirectional.bottomCenter,
      children: [
        _loadingResourceList
            //加载
            ? const Center(
                child: CircularProgressIndicator(),
              )
            //文件列表
            : GridView.builder(
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
                        if (res is SpaceFolder) {
                          //双击进入文件夹
                          if (res.id != null) {}
                        } else if (res is SpaceFile) {}
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
                      try {} on DioException catch (e) {
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
          case "download":
            break;
        }
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
}
