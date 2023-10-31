import 'package:file_client/view/component/topic/topic_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../widget/common_action_one_button.dart';

class SubjectShareEditPage extends StatefulWidget {
  const SubjectShareEditPage({Key? key}) : super(key: key);

  @override
  State<SubjectShareEditPage> createState() => _SubjectShareEditPageState();
}

class _SubjectShareEditPageState extends State<SubjectShareEditPage> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Navigator(
      onGenerateRoute: (val) {
        return PageRouteBuilder(
          pageBuilder: (BuildContext nContext,
              Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 30,
                        width: 100,
                        child: CommonActionOneButton(title: "新建主题"),
                      ),
                    ],
                  ),
                ),
                // Expanded(
                //   child: GridView.builder(
                //     padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                //     // gridDelegate:
                //     // const SliverGridDelegateWithMaxCrossAxisExtent(
                //     //     maxCrossAxisExtent: 250,
                //     //     crossAxisSpacing: 10,
                //     //     mainAxisSpacing: 10,
                //     //     childAspectRatio: 1.7
                //     // ),
                //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                //       crossAxisCount: 4, //横轴三个子widget
                //       childAspectRatio: 1.5,
                //     ),
                //     itemCount: 10,
                //     itemBuilder: (context, index) {
                //       //如果显示到最后一个并且Icon总数小于200时继续获取数据
                //       return TopicItem();
                //     },
                //   ),
                // )
              ],
            );
          },
        );
      },
    );
  }
}
