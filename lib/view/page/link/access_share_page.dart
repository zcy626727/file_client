import 'dart:developer';

import 'package:flutter/material.dart';

import '../../../api/http_status_code.dart';
import '../../../model/common/common_resource.dart';
import '../../../model/file/share.dart';
import '../../../model/file/user_folder.dart';
import '../../../service/file/share_service.dart';
import '../../../service/file/user_file_service.dart';
import '../../component/file/folder_path_list.dart';
import '../../component/file/resource_list_item.dart';
import '../../component/file/select_resource_dialog.dart';
import '../../component/show/show_snack_bar.dart';
import '../../widget/common_action_one_button.dart';
import '../../widget/input_text_field.dart';

class AccessSharePage extends StatefulWidget {
  const AccessSharePage({Key? key, required this.token, this.code, this.initFolderId}) : super(key: key);
  final String token;
  final String? code;
  final int? initFolderId;

  @override
  State<AccessSharePage> createState() => _AccessSharePageState();
}

class _AccessSharePageState extends State<AccessSharePage> {
  int _selectedIndex = -1;
  bool _loadingResourceList = false;

  //文件路径
  List<UserFolder> _pathList = <UserFolder>[];

  List<CommonResource> _fileList = <CommonResource>[];

  late Future _futureBuilderFuture;

  //提取码，由外部传入，内部可以更改
  late String? _code;
  final _codeInputController = TextEditingController(text: "");
  Share? _share;

  //0：正在访问
  int _status = 0;

  Future<void> loadShareData() async {
    await accessShare(token: widget.token, code: _code);
  }

  Future getData() async {
    return Future.wait([loadShareData()]);
  }

  @override
  void initState() {
    _code = widget.code;
    _codeInputController.text = widget.code ?? "";
    _futureBuilderFuture = getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return FutureBuilder(
      future: _futureBuilderFuture,
      builder: (BuildContext context, AsyncSnapshot snapShot) {
        if (snapShot.connectionState == ConnectionState.done) {
          if (_status == AppHttpStatusCode.success) {
            return Column(
              children: [
                _buildTopBar(),
                // _buildOperaList(),
                //用户信息等
                //路径
                _buildPathList(),
                Expanded(
                  child: _fileBody(),
                ),
              ],
            );
          } else if (_status == AppHttpStatusCode.needShareCode || _status == AppHttpStatusCode.shareCodeError) {
            //需要提取码
            return Center(
              child: SizedBox(
                height: 200,
                width: 300,
                child: Column(
                  children: [
                    InputTextField(controller: _codeInputController, title: "提取码", enable: true),
                    const SizedBox(height: 5),
                    CommonActionOneButton(
                      title: "确定",
                      onTap: () async {
                        _code = _codeInputController.text;
                        await accessShare(token: widget.token, code: _code);
                        if (_status == AppHttpStatusCode.shareCodeError) {
                          if (context.mounted) ShowSnackBar.error(context: context, message: "提取码错误");
                        }
                        setState(() {});
                      },
                    )
                  ],
                ),
              ),
            );
          } else if (_status == AppHttpStatusCode.closeShare) {
            return Center(child: Text("分享被暂时关闭", style: TextStyle(color: colorScheme.onSurface)));
          } else if (_status == AppHttpStatusCode.cancelShare) {
            return Center(child: Text("分享不存在或已被被取消", style: TextStyle(color: colorScheme.onSurface)));
          } else {
            return Center(
                child: Text(
              "访问失败",
              style: TextStyle(color: colorScheme.onSurface),
            ));
          }
        } else {
          // 请求未结束，显示loading
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _buildTopBar() {
    var colorScheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            splashRadius: 20,
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
            color: colorScheme.onBackground,
          ),
        ],
      ),
    );
  }

  //todo 写分享者信息、保存按钮等功能
  Widget _buildOperaList() {
    var colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(right: 10),
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            onPressed: () {},
            style: ButtonStyle(
              elevation: MaterialStateProperty.all(0),
              backgroundColor: MaterialStateProperty.all(
                colorScheme.primary.withAlpha(220),
              ),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.save,
                  size: 18,
                ),
                SizedBox(width: 5.0),
                Text("保存资源")
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPathList() {
    return SizedBox(
      height: 30,
      child: FolderPathList(
        margin: const EdgeInsets.only(left: 13.0, top: 1.0),
        folderList: _pathList,
        onTap: (userFolder) async {
          //如果点击的是根目录，这里根目录代表的是分享的根目录，不是用户文件系统的根目录
          setState(() {
            _loadingResourceList = true;
          });
          if (userFolder.id == 0) {
            //根目录
            _pathList = [];
          } else {
            while (_pathList.last.id != userFolder.id) {
              _pathList.removeLast();
            }
          }
          await accessShare(token: widget.token, code: _code);
          setState(() {
            _loadingResourceList = false;
          });
        },
      ),
    );
  }

  Widget _fileBody() {
    return _loadingResourceList
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : GridView.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 160, childAspectRatio: 0.9),
            itemBuilder: (ctx, idx) {
              var res = _fileList[idx];
              return Container(
                margin: const EdgeInsets.all(2.0),
                child: ResourceListItem(
                  onPreTap: () async {
                    setState(
                      () {
                        _selectedIndex = idx;
                      },
                    );
                  },
                  onTap: () {
                    log("单击");
                  },
                  onSecondaryTap: (TapDownDetails details) {
                    moreOpera(context, details, res);
                  },
                  onDoubleTap: () async {
                    setState(() {
                      _loadingResourceList = true;
                    });
                    //是文件夹
                    if (res is UserFolder) {
                      //双击进入文件夹
                      if (res.id != null) {
                        await accessShare(token: widget.token, code: _code, folderId: res.id);
                        _pathList.add(res);
                      }
                    }
                    setState(() {
                      _loadingResourceList = false;
                    });
                  },
                  resource: res,
                  selected: _selectedIndex == idx,
                ),
              );
            },
            itemCount: _fileList.length,
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
          value: 'save',
          child: Text(
            '保存',
            style: TextStyle(color: colorScheme.onSurface.withAlpha(200), fontSize: 14),
          ),
        ),
      ],
    ).then((value) async {
      switch (value) {
        case "save": //重命名
          await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return SelectResourceDialog(
                title: "保存到",
                filterIdSet: <int?>{res.id},
                onConfirm: (targetFolder) async {
                  try {
                    var fileIdList = <int>[];
                    if (res.id == null || targetFolder.id == null) throw const FormatException("保存失败");
                    fileIdList.add(res.id!);
                    await ShareService.saveFileList(token: widget.token, code: _code, userFileIdList: fileIdList, targetFolderId: targetFolder.id!);
                  } on Exception catch (e) {
                    if (context.mounted) ShowSnackBar.exception(context: context, e: e);
                  }
                  if (context.mounted) Navigator.pop(context);
                },
                onLoad: (int parentId, int page) async {
                  var list = await UserFileService.getFolderList(parentId: parentId, pageIndex: page);
                  return list;
                },
              );
            },
          );
          break;
      }
    });
  }

  Future<bool> accessShare({
    required String token,
    String? code,
    int? folderId,
    int page = 0,
  }) async {
    try {
      var (s, share, fileList) = await ShareService.accessShare(token: token, code: code, folderId: folderId, pageIndex: page);
      if (share != null) {
        _share = share;
      }
      _status = s;
      if (s == AppHttpStatusCode.success) {
        _fileList = fileList;
        return true;
      }
      return false;
    } on Exception catch (e) {
      ShowSnackBar.exception(context: context, e: e);
      return false;
    }
  }
}
