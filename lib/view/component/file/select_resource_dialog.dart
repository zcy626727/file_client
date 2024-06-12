import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:file_client/model/common/common_file.dart';
import 'package:file_client/model/common/common_folder.dart';
import 'package:flutter/material.dart';

import '../../../common/list/common_item_list.dart';
import '../../../model/common/common_resource.dart';
import '../../widget/common_action_two_button.dart';
import 'folder_path_list.dart';
import 'resource_list_item.dart';

class SelectResourceDialog extends StatefulWidget {
  const SelectResourceDialog({
    Key? key,
    this.folderId,
    required this.title,
    required this.onConfirm,
    this.fileType = 0,
    required this.onLoad,
    this.filterIdSet,
  }) : super(key: key);

  //初始文件夹，默认为用户根目录
  final int? folderId;
  final int fileType;
  final String title;
  final Set<int?>? filterIdSet;
  final Function(CommonResource) onConfirm;

  // 获取文件列表，给定parentId
  final Future<List<CommonResource>> Function(int parentId, int page) onLoad;

  @override
  State<SelectResourceDialog> createState() => _SelectUserFileDialogState();
}

class _SelectUserFileDialogState extends State<SelectResourceDialog> {
  late Future _futureBuilderFuture;

  //移动文件路径
  final List<CommonFolder> _folderPath = <CommonFolder>[CommonFolder.rootFolder()];

  late CommonResource _selectedResource;

  GlobalKey<CommonItemListState<CommonResource>> listKey = GlobalKey<CommonItemListState<CommonResource>>();

  Future<void> loadFileList(int parentId) async {
    try {} on DioException catch (e) {
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
                  onTap: (folder) async {
                    //点击路径文件夹
                    //移除后面的路径文件夹
                    while (_folderPath.last.id != folder.id) {
                      _folderPath.removeLast();
                    }
                    //更改选择的文件夹
                    _selectedResource = folder;
                    resetFileListKey();
                    setState(() {});
                  },
                  onCurrentTap: (userFolder) {
                    //点击当前的路径文件夹不需要重新获取数据
                    _selectedResource = userFolder;
                    setState(() {});
                  },
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  child: CommonItemList<CommonResource>(
                    key: listKey,
                    onLoad: (int page) async {
                      var list = await widget.onLoad(_folderPath.last.id!, page);
                      // 移除不希望出现的资源
                      if (widget.filterIdSet != null) {
                        for (var value in list) {
                          if (widget.filterIdSet!.contains(value.id)) {
                            list.remove(value);
                          }
                        }
                      }
                      return list;
                    },
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 160, childAspectRatio: 0.9),
                    itemName: "",
                    itemHeight: null,
                    isGrip: false,
                    enableScrollbar: true,
                    itemBuilder: (ctx, item, itemList, onFresh) {
                      return SizedBox(
                        height: 50,
                        child: ResourceListItem(
                          isGrid: false,
                          onPreTap: () {
                            _selectedResource = item;
                            setState(() {});
                          },
                          onDoubleTap: () async {
                            if (item is CommonFolder) {
                              //双击文件夹，进入文件夹
                              //选择当前文件夹
                              _selectedResource = item;
                              //更新路径
                              _folderPath.add(item);
                              resetFileListKey();
                              setState(() {});
                            } else if (item is CommonFile) {
                              _selectedResource = item;
                              setState(() {});
                            }
                          },
                          resource: item,
                          selected: _selectedResource.id == item.id,
                        ),
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

  void resetFileListKey() {
    listKey = GlobalKey<CommonItemListState<CommonResource>>();
  }
}
