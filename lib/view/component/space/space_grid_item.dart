import 'package:file_client/model/space/space.dart';
import 'package:file_client/service/team/space_user_service.dart';
import 'package:file_client/view/component/show/show_snack_bar.dart';
import 'package:file_client/view/component/space/join_space_dialog.dart';
import 'package:flutter/material.dart';

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
        padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 5)),
      ),
      onPressed: () async {
        try {
          if (space.id == null) throw const FormatException("空间状态异常");
          var spaceUser = await SpaceUserService.getSpaceUser(spaceId: space.id!);
          // 如果已加入该空间
          if (spaceUser != null) {
            // 直接进入空间
            if (context.mounted) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return SpacePage(space: space);
                  },
                ),
              );
            }
          } else {
            // 弹出申请界面
            if (context.mounted) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return JoinSpaceDialog(space: space);
                },
              );
            }
          }
        } on Exception catch (e) {
          if (context.mounted) ShowSnackBar.exception(context: context, e: e);
        }
      },
      child: Center(
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(
            //头像半径
            radius: 30,
            backgroundImage: space.avatarUrl == null ? null : NetworkImage(space.avatarUrl!),
            backgroundColor: colorScheme.primary,
          ),
          title: Text(
            space.name ?? "未知",
            style: TextStyle(color: colorScheme.onPrimaryContainer, fontSize: 15),
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            space.description ?? "未知",
            style: TextStyle(color: colorScheme.onPrimaryContainer.withAlpha(100), fontSize: 12),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
