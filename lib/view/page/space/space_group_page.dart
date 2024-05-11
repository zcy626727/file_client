import 'package:file_client/model/space/group.dart';
import 'package:file_client/view/component/space/group/create_group_dialog.dart';
import 'package:file_client/view/component/space/group/group_list_item.dart';
import 'package:flutter/material.dart';

import '../../widget/common_action_one_button.dart';
import '../../widget/common_search_text_field.dart';

class SpaceGroupPage extends StatefulWidget {
  const SpaceGroupPage({super.key});

  @override
  State<SpaceGroupPage> createState() => _SpaceGroupPageState();
}

class _SpaceGroupPageState extends State<SpaceGroupPage> {
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
              backgroundColor: colorScheme.background,
              body: Column(
                children: [
                  const CommonSearchTextField(height: 60),
                  Container(
                    height: 40,
                    margin: const EdgeInsets.only(top: 1, bottom: 1),
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    color: colorScheme.surface,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          height: 30,
                          width: 120,
                          child: CommonActionOneButton(
                            title: "新建分组",
                            onTap: () async {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return CreateGroupDialog();
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: colorScheme.surface,
                      child: ListView.builder(
                        itemCount: 20,
                        itemBuilder: (BuildContext context, int index) {
                          return GroupListItem(group: Group());
                        },
                      ),
                    ),
                  )
                ],
              ));
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
