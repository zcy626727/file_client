import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:file_client/domain/resource.dart';
import 'package:file_client/model/file/user_file.dart';
import 'package:file_client/service/file/user_file_service.dart';
import 'package:flutter/material.dart';

import '../../../constant/resource.dart';
import '../../../model/file/user_folder.dart';
import '../../../service/file/user_folder_service.dart';
import '../../widget/common_action_two_button.dart';
import 'file_list_tile.dart';
import 'folder_path_list.dart';

class SelectUserFileDialog extends StatefulWidget {
  const SelectUserFileDialog({Key? key, this.folderId, required this.title, required this.onConfirm, this.fileType = 0}) : super(key: key);

  //初始文件夹，默认为用户根目录
  final int? folderId;
  final int fileType;
  final String title;
  final Function(Resource) onConfirm;

  @override
  State<SelectUserFileDialog> createState() => _SelectUserFileDialogState();
}

class _SelectUserFileDialogState extends State<SelectUserFileDialog> {
  late Future _futureBuilderFuture;

  //移动文件路径
  List<UserFolder> _folderPath = <UserFolder>[];

  //当前路径的文件夹列表
  List<Resource> _resList = <Resource>[];

  Resource _selectedFolder = UserFolder.rootFolder();

  bool _loadingMoveFolderList = false;

  Future<void> loadFolderAndFileList(int parentId) async {
    try {
      _resList.clear();
      var folderList = await UserFolderService.getFolderList(parentId, <int>[ResourceStatus.normal.index]);
      var fileList = await UserFileService.getFileList(parentId: parentId, statusList: <int>[ResourceStatus.normal.index], fileType: widget.fileType);
      _resList.addAll(folderList);
      _resList.addAll(fileList);
    } on DioException catch (e) {
      log(e.toString());
    } catch (e) {
      log(e.toString());
    }
  }

  Future getData() async {
    return Future.wait([loadFolderAndFileList(widget.folderId ?? 0)]);
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
          return _buildDialog();
        } else {
          // 请求未结束，显示loading
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _buildDialog() {
    var colorScheme = Theme.of(context).colorScheme;
    return AlertDialog(
      contentPadding: const EdgeInsets.all(5.0),
      backgroundColor: colorScheme.surface,
      titlePadding: const EdgeInsets.only(top: 15.0, left: 10.0),
      title: SizedBox(
        width: 250,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: TextStyle(
                color: colorScheme.onSurface.withAlpha(200),
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
      content: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
        return SizedBox(
          width: 250,
          child: Column(
            children: [
              Container(
                height: 30,
                margin: const EdgeInsets.only(right: 5.0),
                child: FolderPathList(
                  margin: const EdgeInsets.only(),
                  folderList: _folderPath,
                  onTap: (userFolder) async {
                    setState(() {
                      _loadingMoveFolderList = true;
                    });
                    _selectedFolder = userFolder;
                    //更新路径和列表
                    if (userFolder.id == 0) {
                      _folderPath.clear();
                    } else {
                      while (_folderPath.last.id != userFolder.id) {
                        _folderPath.removeLast();
                      }
                    }
                    _resList.clear();
                    var folderList = await UserFolderService.getFolderList(userFolder.id!, <int>[ResourceStatus.normal.index]);
                    var fileList = await UserFileService.getFileList(parentId: userFolder.id!, statusList: <int>[ResourceStatus.normal.index], fileType: widget.fileType);
                    _resList.addAll(folderList);
                    _resList.addAll(fileList);
                    setState(() {
                      _loadingMoveFolderList = false;
                    });
                  },
                  onCurrentTap: (userFolder) {
                    //点击当前的路径文件夹不需要重新获取数据
                    setState(() {
                      _loadingMoveFolderList = true;
                    });
                    _selectedFolder = userFolder;
                    setState(() {
                      _loadingMoveFolderList = false;
                    });
                  },
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  child: _loadingMoveFolderList
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : ListView.builder(
                          itemCount: _resList.length,
                          itemExtent: 45,
                          itemBuilder: (BuildContext context, int index) {
                            return FileListItem(
                              isGrid: false,
                              onPreTap: () {
                                setState(() {
                                  _selectedFolder = _resList[index];
                                });
                              },
                              onDoubleTap: () async {
                                var res = _resList[index];
                                if (res is UserFolder) {
                                  setState(() {
                                    _loadingMoveFolderList = true;
                                  });
                                  //双击文件夹
                                  var folder = res;
                                  //选择当前文件夹
                                  _selectedFolder = folder;
                                  //更新路径
                                  _folderPath.add(folder);
                                  //更新列表
                                  _resList.clear();
                                  var folderList = await UserFolderService.getFolderList(folder.id!, <int>[ResourceStatus.normal.index]);
                                  var fileList = await UserFileService.getFileList(parentId: folder.id!, statusList: <int>[ResourceStatus.normal.index], fileType: widget.fileType);
                                  _resList.addAll(folderList);
                                  _resList.addAll(fileList);
                                  setState(() {
                                    _loadingMoveFolderList = false;
                                  });
                                }
                              },
                              resource: _resList[index],
                              selected: _selectedFolder.id == _resList[index].id,
                            );
                          },
                        ),
                ),
              )
            ],
          ),
        );
      }),
      actions: <Widget>[
        CommonActionTwoButton(
          height: 35,
          onLeftTap: () {
            Navigator.pop(context);
          },
          onRightTap: () async {
            await widget.onConfirm(_selectedFolder);
          },
        )
      ],
    );
  }
}
