import 'package:file_client/config/global.dart';
import 'package:file_client/view/component/space/member/member_list_item.dart';
import 'package:file_client/view/widget/common_search_text_field.dart';
import 'package:flutter/material.dart';

class SpaceMemberPage extends StatefulWidget {
  const SpaceMemberPage({super.key});

  @override
  State<SpaceMemberPage> createState() => _SpaceMemberPageState();
}

class _SpaceMemberPageState extends State<SpaceMemberPage> {
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
              body: Column(
                children: [
                  CommonSearchTextField(height: 60),
                  Expanded(
                    child: ListView.builder(
                      itemCount: 20,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          margin: const EdgeInsets.only(top: 5, left: 15, right: 15),
                          child: MemberListItem(user: Global.user),
                        );
                      },
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
