import 'dart:developer';

import 'package:file_client/view/component/album/album_item.dart';
import 'package:flutter/material.dart';

import '../../component/share/share_resource_grid_item.dart';
import '../../widget/common_action_one_button.dart';

class VideoShareEditPage extends StatefulWidget {
  const VideoShareEditPage({Key? key}) : super(key: key);

  @override
  State<VideoShareEditPage> createState() => _VideoShareEditPageState();
}

class _VideoShareEditPageState extends State<VideoShareEditPage> {
  int _mode = 0;

  @override
  Widget build(BuildContext context) {
    log("合集列表构建");
    var width = MediaQuery.of(context).size.width;

    var modeStr = "";
    if (_mode == 0) {
      modeStr = "文件模式";
    } else if (_mode == 1) {
      modeStr = "合集模式";
    }
    var colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(
            left: 5.0,
            right: 5.0,
            top: 5.0,
          ),
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 30,
                width: 100,
                child: CommonActionOneButton(
                  title: "切换模式",
                  onTap: () {
                    setState(() {
                      _mode = (_mode + 1) % 2;
                    });
                  },
                ),
              ),
              Chip(
                backgroundColor: colorScheme.secondary,
                label: Text(
                  modeStr,
                  style: TextStyle(
                    color: colorScheme.onSecondary,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
              Row(
                children: [
                  if (_mode == 0)
                    SizedBox(
                      height: 30,
                      width: 100,
                      child: CommonActionOneButton(title: "添加文件"),
                    ),
                  if (_mode == 1)
                    SizedBox(
                      height: 30,
                      width: 100,
                      child: CommonActionOneButton(title: "创建合集"),
                    ),
                ],
              )
            ],
          ),
        ),
        if (_mode == 0)
          Expanded(
            child: GridView.builder(
              padding:
                  const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: width > 1300.0 ? 5 : 4, //横轴三个子widget
                childAspectRatio: 1.2,
              ),
              itemCount: 200,
              itemBuilder: (context, index) {
                //如果显示到最后一个并且Icon总数小于200时继续获取数据
                // return ShareResourceGridItem();
                return const ShareResourceGridItem();
              },
            ),
          ),
        // if (_mode == 1)
          // Expanded(
          //   child: GridView.builder(
          //     padding:
          //         const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
          //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //       crossAxisCount: width > 1300.0 ? 5 : 4, //横轴三个子widget
          //       childAspectRatio: 2,
          //       mainAxisSpacing: 5.0,
          //       crossAxisSpacing: 5.0,
          //     ),
          //     itemCount: 200,
          //     itemBuilder: (context, index) {
          //       //如果显示到最后一个并且Icon总数小于200时继续获取数据
          //       // return ShareResourceGridItem();
          //       return AlbumItem(
          //         key: ValueKey(index),
          //       );
          //     },
          //   ),
          // ),
      ],
    );
  }
}
