import 'dart:developer';

import 'package:flutter/material.dart';

import '../../../api/http_status_code.dart';
import '../../../domain/resource.dart';
import '../../../model/file/share.dart';
import '../../../model/file/user_file.dart';
import '../../../model/file/user_folder.dart';
import '../../../service/file/share_service.dart';
import '../../component/file/folder_path_list.dart';
import '../../component/file/select_folder_dialog.dart';
import '../../component/file/file_list_tile.dart';
import '../../component/show/show_snack_bar.dart';
import '../../widget/common_action_one_button.dart';
import '../../widget/input_text_field.dart';

class ShareContextPage extends StatefulWidget {
  const ShareContextPage({Key? key, required this.share, this.code, this.initFolderId}) : super(key: key);
  final Share share;
  final String? code;
  final int? initFolderId;

  @override
  State<ShareContextPage> createState() => _ShareContextPageState();
}

class _ShareContextPageState extends State<ShareContextPage> {
  int _selectedIndex = -1;
  bool _loadingResourceList = false;

  //文件路径
  List<UserFolder> _pathList = <UserFolder>[];

  List<Resource> _resourceList = <Resource>[];

  late Future _futureBuilderFuture;

  //提取码，由外部传入，内部可以更改
  late String? _code;
  final _codeInputController = TextEditingController(text: "");

  //-1：正常，0：访问失败，1：需要提取码
  String status = "";

  Future<void> loadShareData() async {
    var (s, r) = await ShareService.getShareData(widget.share.id!, _code, widget.initFolderId);
    if (widget.initFolderId != null) {
      _pathList = await ShareService.getFolderPathInShare(widget.share.id!, _code, widget.initFolderId!);
    }
    status = s;
    _resourceList = r;
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
    return FutureBuilder(
      future: _futureBuilderFuture,
      builder: (BuildContext context, AsyncSnapshot snapShot) {
        if (snapShot.connectionState == ConnectionState.done) {
          if (status == AppHttpStatusCode.success) {
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
          } else if (status == AppHttpStatusCode.needShareCode || status == AppHttpStatusCode.unableShareCode) {
            //一个输入框
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
                        var (s, r) = await ShareService.getShareData(widget.share.id!, _code, widget.initFolderId);
                        if (widget.initFolderId != null) {
                          _pathList = await ShareService.getFolderPathInShare(widget.share.id!, _code, widget.initFolderId!);
                        }
                        status = s;
                        _resourceList = r;
                        if (status == AppHttpStatusCode.unableShareCode) {
                          if (mounted) ShowSnackBar.error(context: context, message: "提取码错误");
                        }
                        setState(() {});
                      },
                    )
                  ],
                ),
              ),
            );
          } else {
            return const Center(
              child: Text("访问失败"),
            );
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
            child: Row(
              children: const [
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

          var (s, r) = await ShareService.getShareData(widget.share.id!, _code, userFolder.id!);
          if (s == AppHttpStatusCode.success) {
            _resourceList = r;
          } else {
            //todo 处理错误
          }
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
              var res = _resourceList[idx];
              return Container(
                margin: const EdgeInsets.all(2.0),
                child: FileListItem(
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
                        var (_, r) = await ShareService.getShareData(widget.share.id!, _code, res.id!);
                        _pathList.add(res);
                        _resourceList = r;
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
            itemCount: _resourceList.length,
          );
  }

  void moreOpera(BuildContext context, TapDownDetails details, Resource res) {
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
              return SelectFolderDialog(
                  title: "保存到",
                  onConfirm: (targetFolder) {
                    var folderList = <UserFolder>[];
                    var fileList = <UserFile>[];
                    if (res is UserFile) {
                      fileList.add(res);
                    } else if (res is UserFolder) {
                      folderList.add(res);
                    }
                    ShareService.saveResourceList(fileList, folderList, widget.share.id!, _code, targetFolder.id!, _pathList.isEmpty);
                    Navigator.pop(context);
                  });
            },
          );
          break;
      }
    });
  }
}
