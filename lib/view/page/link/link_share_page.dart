import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../constant/share.dart';
import '../../../model/file/share.dart';
import '../../../service/file/share_service.dart';
import '../../component/share/link_share_detail_dialog.dart';
import '../../component/show/show_snack_bar.dart';
import '../../widget/confirm_alert_dialog.dart';

class LinkSharePage extends StatefulWidget {
  const LinkSharePage({Key? key}) : super(key: key);

  @override
  State<LinkSharePage> createState() => _LinkSharePageState();
}

class _LinkSharePageState extends State<LinkSharePage> {
  bool loading = false;

  late Future _futureBuilderFuture;

  List<Share> _shareList = <Share>[];

  Future<void> loadShareList() async {
    _shareList = await ShareService.getShareList();
  }

  Future getData() async {
    return Future.wait([loadShareList()]);
  }

  @override
  void initState() {
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
          return _shareListBuild();
        } else {
          // 请求未结束，显示loading
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _shareListBuild() {
    var colorScheme = Theme.of(context).colorScheme;
    var textStyle = TextStyle(color: colorScheme.onBackground.withAlpha(200), fontSize: 14);
    return Column(
      children: [
        Expanded(
          child: SizedBox(
            width: double.infinity,
            child: DataTable(
              columns: [
                DataColumn(label: Text("名字", style: TextStyle(color: colorScheme.onSurface))),
                DataColumn(label: Text("开始时间", style: TextStyle(color: colorScheme.onSurface))),
                DataColumn(label: Text("截止时间", style: TextStyle(color: colorScheme.onSurface))),
                DataColumn(label: Text("状态", style: TextStyle(color: colorScheme.onSurface))),
                DataColumn(
                  label: Container(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Text(
                      "操作",
                      style: TextStyle(color: colorScheme.onSurface),
                    ),
                  ),
                ),
              ],
              rows: [
                ...List.generate(_shareList.length, (index) {
                  var share = _shareList[index];
                  String statusText = "";
                  if (share.status == ShareStatus.normal.index) {
                    statusText = "分享中";
                  } else if (share.status == ShareStatus.cancel.index) {
                    statusText = "关闭中";
                  }
                  bool isEnd = false;
                  //过期了
                  if (share.endTime!.isBefore(DateTime.now())) {
                    isEnd = true;
                    statusText = "分享过期";
                  }
                  return DataRow(
                    cells: [
                      DataCell(Text(
                        share.name!,
                        style: TextStyle(color: colorScheme.onSurface),
                      )),
                      DataCell(Text(
                        DateFormat("yyyy-MM-dd").format(share.createTime!),
                        style: TextStyle(color: colorScheme.onSurface),
                      )),
                      DataCell(Text(
                        DateFormat("yyyy-MM-dd").format(share.endTime!),
                        style: TextStyle(color: colorScheme.onSurface),
                      )),
                      DataCell(Text(
                        statusText,
                        style: TextStyle(color: colorScheme.onSurface),
                      )),
                      DataCell(
                        PopupMenuButton(
                          color: colorScheme.surface,
                          itemBuilder: (ctx) {
                            return [
                              PopupMenuItem(
                                height: 35,
                                onTap: () async {
                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                    showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (BuildContext context) {
                                        return LinkShareDetailDialog(share: share);
                                      },
                                    );
                                  });
                                },
                                child: Text("详细信息", style: textStyle, overflow: TextOverflow.ellipsis),
                              ),
                              PopupMenuItem(
                                height: 35,
                                onTap: () async {
                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                    showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (BuildContext context) {
                                        return ConfirmAlertDialog(
                                          text: "确认删除",
                                          onConfirm: () async {
                                            try {
                                              await ShareService.deleteShare(share.id!);
                                              _shareList.remove(share);
                                              if (mounted) Navigator.pop(context);
                                              setState(() {});
                                            } on Exception catch (e) {
                                              ShowSnackBar.exception(context: context, e: e, defaultValue: "取消分享失败");
                                            }
                                          },
                                          onCancel: () {
                                            Navigator.pop(context);
                                          },
                                        );
                                      },
                                    );
                                  });
                                },
                                child: Text("取消分享", style: textStyle, overflow: TextOverflow.ellipsis),
                              ),
                              if (!isEnd && share.status == ShareStatus.normal.index)
                                PopupMenuItem(
                                  value: "close",
                                  height: 35,
                                  onTap: () async {
                                    try {
                                      await ShareService.updateShareStatus(share.id!, ShareStatus.cancel.index);
                                      share.status = ShareStatus.cancel.index;
                                      setState(() {});
                                    } on Exception catch (e) {
                                      ShowSnackBar.exception(context: context, e: e, defaultValue: "关闭分享失败");
                                    }
                                  },
                                  child: Text(
                                    "关闭分享",
                                    style: textStyle,
                                  ),
                                ),
                              if (!isEnd && share.status == ShareStatus.cancel.index)
                                PopupMenuItem(
                                  height: 35,
                                  onTap: () async {
                                    try {
                                      await ShareService.updateShareStatus(share.id!, ShareStatus.normal.index);
                                      share.status = ShareStatus.normal.index;
                                      setState(() {});
                                    } on Exception catch (e) {
                                      ShowSnackBar.exception(context: context, e: e, defaultValue: "打开分享失败");
                                    }
                                  },
                                  child: Text(
                                    "开启分享",
                                    style: textStyle,
                                  ),
                                ),
                            ];
                          },
                          icon:  Icon(Icons.more_horiz,color: colorScheme.onSurface,),
                          splashRadius: 16,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                              width: 1,
                              color: colorScheme.onSurface.withAlpha(30),
                              style: BorderStyle.solid,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
        )
      ],
    );
  }
}
