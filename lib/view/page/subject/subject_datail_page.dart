import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';

import '../../widget/common_action_one_button.dart';
import '../../widget/common_tab_bar.dart';

class SubjectDetailPage extends StatefulWidget {
  const SubjectDetailPage({Key? key}) : super(key: key);

  @override
  State<SubjectDetailPage> createState() => _SubjectDetailPageState();
}

class _SubjectDetailPageState extends State<SubjectDetailPage> {
  final tabBarList = <String>["动漫", "小说", "漫画（第一部）", "漫画（第二部）", "插曲"];

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Container(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: [
            SizedBox(
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
                  IconButton(
                    onPressed: () {},
                    splashRadius: 20,
                    icon: const Icon(Icons.settings),
                  ),
                ],
              ),
            ),
            Divider(color: Colors.grey.withAlpha(100), height: 1),
            SizedBox(
              height: 150,
              child: Row(
                children: [
                  Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    width: 150,
                    height: 150,
                    child: const Image(
                      image: NetworkImage(
                        'http://5b0988e595225.cdn.sohucs.com/images/20200224/42336aed508f4aa28db138fd43396b28.jpeg',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "拳愿阿修罗",
                              style: TextStyle(
                                color: colorScheme.onSurface,
                                fontWeight: FontWeight.w700,
                                fontSize: 40,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 4),
                              height: 30,
                              width: 200,
                              child: CommonActionOneButton(
                                title: "订阅（2100）",
                                backgroundColor: colorScheme.primary,
                                textColor: colorScheme.onPrimary,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 5),
                              height: 20,
                              child: ClipOval(
                                child: Image.network(
                                  'https://pic2.zhimg.com/v2-639b49f2f6578eabddc458b84eb3c6a1.jpg',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Text(
                              "克里斯蒂安-宇",
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Container(
                            height: 70,
                            width: double.infinity,
                            padding:
                                const EdgeInsets.only(top: 10.0, bottom: 5.0),
                            child: MasonryGridView.count(
                              scrollDirection: Axis.horizontal,
                              crossAxisCount: 2,
                              crossAxisSpacing: 5.0,
                              mainAxisSpacing: 5.0,
                              itemCount: 17,
                              itemBuilder: (ctx, index) {
                                return Chip(
                                  label: Text(
                                    'ab',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  padding: EdgeInsets.only(bottom: 3),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: DefaultTabController(
                length: tabBarList.length,
                child: Column(
                  children: [
                    CommonTabBar(
                      titleTextList: tabBarList,
                    ),
                    Expanded(
                      child: TabBarView(
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          Container(
                              child: ListView.builder(
                                  itemCount: 100,
                                  itemBuilder: (ctx, index) {
                                    return Container(
                                      child: ListTile(
                                        onTap: () {},
                                        contentPadding: EdgeInsets.zero,
                                        leading: Image.network(
                                          'http://5b0988e595225.cdn.sohucs.com/images/20200224/42336aed508f4aa28db138fd43396b28.jpeg',
                                          fit: BoxFit.cover,
                                        ),
                                        title: Text(
                                          "第一集",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: colorScheme.onSurface,
                                              fontSize: 15),
                                        ),
                                        subtitle: Text(
                                          DateFormat("yyyy-MM-dd")
                                              .format(DateTime.now()),
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              color: Colors.grey, fontSize: 12),
                                        ),
                                        trailing: SizedBox(
                                          width: 100,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "#$index",
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12,
                                                ),
                                              ),
                                              Material(
                                                color: Colors.transparent,
                                                child: IconButton(
                                                  splashRadius: 20,
                                                  onPressed: () {},
                                                  icon: Icon(Icons.more_horiz,
                                                      color: colorScheme
                                                          .onSurface),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  })),
                          Text("小说"),
                          Text("1"),
                          Text("1"),
                          Text("1"),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
