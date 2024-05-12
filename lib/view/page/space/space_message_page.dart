import 'package:flutter/material.dart';

import '../../../config/constants.dart';
import '../../widget/common_tab_bar.dart';
import '../../widget/confirm_alert_dialog.dart';

class SpaceMessagePage extends StatefulWidget {
  const SpaceMessagePage({super.key});

  @override
  State<SpaceMessagePage> createState() => _SpaceMessagePageState();
}

class _SpaceMessagePageState extends State<SpaceMessagePage> {
  late Future _futureBuilderFuture;

  @override
  void initState() {
    super.initState();
    _futureBuilderFuture = getData();
  }

  Future getData() async {
    return Future.wait([]);
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    return FutureBuilder(
      future: _futureBuilderFuture,
      builder: (BuildContext context, AsyncSnapshot snapShot) {
        if (snapShot.connectionState == ConnectionState.done) {
          return Scaffold(
            backgroundColor: colorScheme.surface,
            body: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  const CommonTabBar(
                    titleTextList: ["申请信息", "其他消息"],
                  ),
                  Expanded(
                    child: Container(
                      child: TabBarView(
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          ListView.builder(
                            itemCount: 19,
                            itemBuilder: (BuildContext context, int index) {
                              //点击后返回当前group
                              return Container(
                                margin: const EdgeInsets.only(top: 5, left: 5, right: 15),
                                decoration: BoxDecoration(
                                  color: colorScheme.primaryContainer,
                                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                                ),
                                child: ListTile(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  contentPadding: EdgeInsets.only(right: 5),
                                  leading: CircleAvatar(
                                    //头像半径
                                    radius: 30,
                                    backgroundImage: NetworkImage(errImageUrl),
                                    backgroundColor: colorScheme.primary,
                                  ),
                                  title: Text(
                                    "用户名",
                                    style: TextStyle(color: colorScheme.onPrimaryContainer, fontSize: 15),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  subtitle: Text(
                                    "申请加入",
                                    style: TextStyle(color: colorScheme.onPrimaryContainer.withAlpha(100), fontSize: 12),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  trailing: Container(
                                    width: 100,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          height: 30,
                                          width: 30,
                                          child: IconButton(
                                            padding: EdgeInsets.zero,
                                            tooltip: "同意",
                                            onPressed: () {
                                              //弹出对话框
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext dialogContext) {
                                                  return ConfirmAlertDialog(
                                                    text: "是否同意？",
                                                    onConfirm: () async {},
                                                    onCancel: () {
                                                      Navigator.pop(dialogContext);
                                                    },
                                                  );
                                                },
                                              );
                                            },
                                            icon: const Icon(Icons.done, size: 20),
                                            color: colorScheme.onPrimaryContainer,
                                          ),
                                        ),
                                        Container(
                                          height: 30,
                                          width: 30,
                                          child: IconButton(
                                            padding: EdgeInsets.zero,
                                            tooltip: "拒绝",
                                            onPressed: () {
                                              //弹出对话框
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext dialogContext) {
                                                  return ConfirmAlertDialog(
                                                    text: "是否拒绝？",
                                                    onConfirm: () async {},
                                                    onCancel: () {
                                                      Navigator.pop(dialogContext);
                                                    },
                                                  );
                                                },
                                              );
                                            },
                                            icon: const Icon(Icons.clear, size: 20),
                                            color: colorScheme.onPrimaryContainer,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          Container(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
}
