import 'package:file_client/model/space/space.dart';
import 'package:file_client/view/component/space/join_space_dialog.dart';
import 'package:flutter/material.dart';

import '../../../config/constants.dart';
import '../../page/space/space_page.dart';

class SpaceGridItem extends StatelessWidget {
  const SpaceGridItem({super.key, required this.space});

  final Space space;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    return TextButton(
      style: ButtonStyle(
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          backgroundColor: MaterialStateProperty.all(colorScheme.primaryContainer),
          padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 5))),
      onPressed: () {
        // 如果已加入该空间
        if (false) {
          // 直接进入空间
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return SpacePage(space: space);
              },
            ),
          );
        } else {
          // 弹出申请界面
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return const JoinSpaceDialog();
            },
          );
        }
      },
      child: Center(
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(
            //头像半径
            radius: 30,
            backgroundImage: const NetworkImage(errImageUrl),
            backgroundColor: colorScheme.primary,
          ),
          title: Text(
            "空间名",
            style: TextStyle(color: colorScheme.onPrimaryContainer, fontSize: 15),
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            "介绍",
            style: TextStyle(color: colorScheme.onPrimaryContainer.withAlpha(100), fontSize: 12),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
