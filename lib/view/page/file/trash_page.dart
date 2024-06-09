import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../model/file/trash.dart';
import '../../../service/file/trash_service.dart';
import '../../component/file/file_list_tile.dart';
import '../../component/show/show_snack_bar.dart';
import '../../widget/confirm_alert_dialog.dart';

class TrashPage extends StatefulWidget {
  const TrashPage({Key? key}) : super(key: key);

  @override
  State<TrashPage> createState() => _TrashPageState();
}

class _TrashPageState extends State<TrashPage> {
  int _selectedIndex = -1;

  bool loading = false;

  late Future _futureBuilderFuture;

  List<Trash> _trashList = <Trash>[];

  final List<Trash> _selectedTrashList = [];

  bool _checkMode = false;

  Future<void> loadTrashList() async {
    try {
      _trashList = await TrashService.getTrashList();
      loading = false;
    } on DioException catch (e) {
      log(e.toString());
    } catch (e) {
      log(e.toString());
    }
  }

  Future getData() async {
    return Future.wait([loadTrashList()]);
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
          return Column(
            children: [
              //todo 这里回收站可能有不同类型，比如图片、文件等
              _operaList(),
              // _navBar(),
              Expanded(
                child: _fileBody(),
              ),
            ],
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

  Widget _operaList() {
    var colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.only(left: 10.0, right: 5.0, top: 6.0),
      height: 45,
      child: Row(
        children: [
          SizedBox(
            height: 25,
            child: ElevatedButton(
              onPressed: () async {
                _checkMode = !_checkMode;
                _selectedTrashList.clear();
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

  Widget _fileBody() {
    var colorScheme = Theme.of(context).colorScheme;

    return Stack(
      fit: StackFit.expand,
      alignment: AlignmentDirectional.bottomCenter,
      children: [
        loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 160, childAspectRatio: 0.9),
                itemBuilder: (ctx, idx) {
                  var trash = _trashList[idx];
                  return Container(
                    margin: const EdgeInsets.all(2.0),
                    child: ResourceListItem(
                      key: ValueKey("${trash.id}-$_checkMode"),
                      isCheckMode: _checkMode,
                      onPreTap: () async {
                        setState(() {
                          _selectedIndex = idx;
                        });
                      },
                      onTap: () {
                        log("单击");
                      },
                      onSecondaryTap: (TapDownDetails details) {
                        moreOpera(context, details, trash);
                      },
                      onDoubleTap: () async {
                        log("双击");
                      },
                      onCheck: (b) {
                        if (b) {
                          _selectedTrashList.add(trash);
                        } else {
                          _selectedTrashList.remove(trash);
                        }
                      },
                      resource: trash.file!,
                      selected: _selectedIndex == idx,
                    ),
                  );
                },
                itemCount: _trashList.length,
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
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return ConfirmAlertDialog(
                                  text: "是否确定恢复？",
                                  onConfirm: () async {
                                    try {
                                      var trashIdList = <int>[];
                                      for (var trash in _selectedTrashList) {
                                        trashIdList.add(trash.id!);
                                      }

                                      await TrashService.recoverTrashList(trashIdList: trashIdList);

                                      for (var trash in _selectedTrashList) {
                                        _trashList.remove(trash);
                                      }
                                      cancelCheck();
                                      setState(() {});
                                    } on DioException catch (e) {
                                      if (context.mounted) ShowSnackBar.exception(context: context, e: e, defaultValue: "恢复失败");
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
                          Icons.settings_backup_restore,
                          color: colorScheme.onPrimaryContainer,
                          size: 19,
                        ),
                      ),
                      IconButton(
                        splashRadius: 18,
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return ConfirmAlertDialog(
                                text: "是否确定删除？",
                                onConfirm: () async {
                                  try {
                                    var trashIdList = <int>[];
                                    for (var trash in _selectedTrashList) {
                                      trashIdList.add(trash.id!);
                                    }
                                    await TrashService.deleteTrashList(trashIdList: trashIdList);
                                    for (var trash in _selectedTrashList) {
                                      _trashList.remove(trash);
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
                          size: 19,
                        ),
                      ),
                    ],
                  ),
                ),
              ))
      ],
    );
  }

  void moreOpera(BuildContext context, TapDownDetails details, Trash trash) {
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
        globalPosition.dx,
        globalPosition.dy,
        globalPosition.dx,
        globalPosition.dy,
      ),
      items: [
        PopupMenuItem(
          height: 35,
          value: 'recover',
          child: Text(
            '恢复',
            style: TextStyle(color: colorScheme.onSurface.withAlpha(200), fontSize: 14),
          ),
        ),
        PopupMenuItem(
          height: 35,
          value: 'delete',
          child: Text(
            '彻底删除',
            style: TextStyle(color: colorScheme.onBackground.withAlpha(200), fontSize: 14),
          ),
        ),
      ],
    ).then((value) async {
      switch (value) {
        case "recover": //恢复
          try {
            if (trash.id == null) throw const FormatException("恢复失败");
            await TrashService.recoverTrash(trashId: trash.id!);
            setState(() {
              _trashList.remove(trash);
            });
          } on DioException catch (e) {
            String msg = "恢复失败";
            var err = e.error;
            if (err is FormatException) {
              msg = err.source.toString();
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  msg,
                  style: const TextStyle(color: Colors.white),
                ),
                elevation: 10,
                behavior: SnackBarBehavior.floating,
                width: 200,
                showCloseIcon: true,
                duration: const Duration(milliseconds: 1000),
                backgroundColor: Colors.red,
              ),
            );
          }
          break;
        case "delete":
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return ConfirmAlertDialog(
                    text: "确定彻底删除？",
                    onConfirm: () async {
                      try {
                        if (trash.id == null) throw const FormatException("删除失败，请刷新重试");
                        await TrashService.deleteTrash(trashId: trash.id!);
                        setState(() {
                          _trashList.remove(trash);
                        });
                      } on DioException catch (e) {
                        String msg = "删除失败";
                        var err = e.error;
                        if (err is FormatException) {
                          msg = err.source.toString();
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              msg,
                              style: const TextStyle(color: Colors.white),
                            ),
                            elevation: 10,
                            behavior: SnackBarBehavior.floating,
                            width: 200,
                            showCloseIcon: true,
                            duration: const Duration(milliseconds: 1000),
                            backgroundColor: Colors.red,
                          ),
                        );
                      } finally {
                        Navigator.pop(context);
                      }
                    },
                    onCancel: () {
                      Navigator.pop(context);
                    });
              });
          break;
      }
    });
  }

  void cancelCheck() {
    _selectedTrashList.clear();
    _checkMode = false;
  }
}
