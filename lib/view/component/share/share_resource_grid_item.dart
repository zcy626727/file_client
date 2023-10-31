import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ShareResourceGridItem extends StatefulWidget {
  const ShareResourceGridItem(
      {Key? key,
      this.enableUserInfo = true,
      this.enableTag = true,
      this.mode = 0})
      : super(key: key);

  final bool enableUserInfo;
  final bool enableTag;
  final int mode;

  @override
  State<ShareResourceGridItem> createState() => _ShareResourceGridItemState();
}

class _ShareResourceGridItemState extends State<ShareResourceGridItem> {
  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    log("构建集");
    if (widget.mode == 1) {
      return Center(
        child: Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: colorScheme.surfaceTint.withAlpha(15),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: ListTile(
            onTap: () {},
            contentPadding: EdgeInsets.zero,
            leading: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              //这个集合的类型
              child: Icon(Icons.audio_file, color: colorScheme.onPrimary),
            ),
            title: Text(
              "第一集",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: colorScheme.onSurface, fontSize: 15),
            ),
            subtitle: Text(
              DateFormat("yyyy-MM-dd").format(DateTime.now()),
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            trailing: Material(
              color: Colors.transparent,
              child: IconButton(
                splashRadius: 20,
                onPressed: () {},
                icon: Icon(Icons.more_vert, color: colorScheme.onSurface),
              ),
            ),
          ),
        ),
      );
    } else {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          hoverColor: Colors.grey.withAlpha(50),
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.all(6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    child: Image(
                      image: NetworkImage(
                        'http://inews.gtimg.com/newsapp_match/0/15637780499/0',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 3.0, bottom: 3.0),
                  child: Text(
                    "fgo角色",
                    style: TextStyle(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                  ),
                ),
                if (widget.enableUserInfo)
                  Container(
                    color: Colors.transparent,
                    margin: const EdgeInsets.only(bottom: 8),
                    height: 23,
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 5),
                          height: 20,
                          child: ClipOval(
                            child: Image.network(
                              'https://pic2.zhimg.com/v2-639b49f2f6578eabddc458b84eb3c6a1.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Text(
                          "路由器",
                          style: TextStyle(
                              color: colorScheme.onSurface, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                // if (widget.enableTag)
                //   Container(
                //     color: Colors.transparent,
                //     height: 20,
                //     child: ListView(
                //       scrollDirection: Axis.horizontal,
                //       children: [
                //         Chip(
                //           label: const Text(
                //             '动漫',
                //             style: TextStyle(fontSize: 12),
                //           ),
                //           padding: const EdgeInsets.only(bottom: 6.0),
                //         ),
                //         Padding(
                //           padding: const EdgeInsets.only(left: 5.0),
                //           child: Chip(
                //             label: const Text('游戏',
                //                 style: TextStyle(fontSize: 12)),
                //             padding: const EdgeInsets.only(bottom: 6.0),
                //           ),
                //         ),
                //         Padding(
                //           padding: const EdgeInsets.only(left: 5.0),
                //           child: Chip(
                //             label: const Text('18禁',
                //                 style: TextStyle(fontSize: 12)),
                //             padding: const EdgeInsets.only(bottom: 6.0),
                //           ),
                //         ),
                //       ],
                //     ),
                //   )
              ],
            ),
          ),
        ),
      );
    }
  }
}
