import 'package:flutter/material.dart';

import '../../widget/common_tab_bar.dart';

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
                          Container(),
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
