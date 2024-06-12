import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:file_client/model/common/common_folder.dart';
import 'package:flutter/material.dart';

import '../../../model/common/common_resource.dart';
import '../../widget/common_action_two_button.dart';
import 'file_list_tile.dart';
import 'folder_path_list.dart';

class SelectResourceDialog extends StatefulWidget {
  const SelectResourceDialog({Key? key, this.folderId, required this.title, required this.onConfirm, this.fileType = 0, required this.onLoad}) : super(key: key);

  //初始文件夹，默认为用户根目录
  final int? folderId;
  final int fileType;
  final String title;
  final Function(CommonResource?) onConfirm;

  // 获取文件列表，给定parentId
  final Future<List<CommonResource>> Function(int) onLoad;

  @override
  State<SelectResourceDialog> createState() => _SelectUserFileDialogState();
}

class _SelectUserFileDialogState extends State<SelectResourceDialog> {
  late Future _futureBuilderFuture;

  //移动文件路径
  final List<CommonFolder> _folderPath = <CommonFolder>[CommonFolder.rootFolder()];

  //当前路径的文件夹列表
  final List<CommonResource> _resourceList = <CommonResource>[];

  late CommonResource _selectedResource;

  bool _loadingMoveFolderList = false;

  Future<void> loadFileList(int parentId) async {
    try {
      _resourceList.clear();
      // 第一次获取
      var list = await widget.onLoad(parentId);
      _resourceList.addAll(list);
    } on DioException catch (e) {
      log(e.toString());
    } catch (e) {
      log(e.toString());
    }
  }

  Future getData() async {
    return Future.wait([loadFileList(widget.folderId ?? 0)]);
  }

  @override
  void initState() {
    super.initState();
    _futureBuilderFuture = getData();
    _selectedResource = _folderPath[0];
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
                    _selectedResource = userFolder;
                    //更新路径和列表
                    while (_folderPath.last.id != userFolder.id) {
                      _folderPath.removeLast();
                    }
                    _resourceList.clear();
                    var list = await widget.onLoad(userFolder.id!);
                    _resourceList.addAll(list);
                    setState(() {
                      _loadingMoveFolderList = false;
                    });
                  },
                  onCurrentTap: (userFolder) {
                    //点击当前的路径文件夹不需要重新获取数据
                    setState(() {
                      _loadingMoveFolderList = true;
                    });
                    _selectedResource = userFolder;
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
                          itemCount: _resourceList.length,
                          itemExtent: 45,
                          itemBuilder: (BuildContext context, int index) {
                            return ResourceListItem(
                              isGrid: false,
                              onPreTap: () {
                                setState(() {
                                  _selectedResource = _resourceList[index];
                                });
                              },
                              onDoubleTap: () async {
                                var res = _resourceList[index];
                                if (res is CommonFolder) {
                                  //双击文件夹
                                  setState(() {
                                    _loadingMoveFolderList = true;
                                  });
                                  //双击文件夹
                                  var folder = res;
                                  //选择当前文件夹
                                  _selectedResource = folder;
                                  //更新路径
                                  _folderPath.add(folder);
                                  //更新列表
                                  _resourceList.clear();
                                  var list = await widget.onLoad(folder.id!);
                                  _resourceList.addAll(list);
                                  setState(() {
                                    _loadingMoveFolderList = false;
                                  });
                                }
                              },
                              resource: _resourceList[index],
                              selected: _selectedResource?.id == _resourceList[index].id,
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
            await widget.onConfirm(_selectedResource);
          },
        )
      ],
    );
  }
}
