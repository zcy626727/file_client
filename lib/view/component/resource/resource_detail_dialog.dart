import 'package:file_client/model/common/common_resource.dart';
import 'package:file_client/model/space/group.dart';
import 'package:file_client/model/space/space.dart';
import 'package:file_client/model/space/space_file.dart';
import 'package:file_client/model/space/space_folder.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../constant/ui.dart';
import '../../../model/user/user.dart';
import '../../widget/common_action_two_button.dart';
import '../space/member/select_group_dialog.dart';

class ResourceDetailDialog extends StatefulWidget {
  const ResourceDetailDialog({super.key, required this.resource, required this.space});

  final CommonResource resource;
  final Space space;

  @override
  State<ResourceDetailDialog> createState() => _ResourceDetailDialogState();
}

class _ResourceDetailDialogState extends State<ResourceDetailDialog> {
  late User owner = User.testUser();
  late Group group = Group.testGroup();
  int groupPermission = 1;
  int otherPermission = 1;

  @override
  Widget build(BuildContext context) {
    var res = widget.resource;

    String? otherPermissionStr;
    String? groupPermissionStr;
    if (res is SpaceFile) {
      otherPermissionStr = res.otherPermission.toString();
      groupPermissionStr = res.groupPermission.toString();
    } else if (res is SpaceFolder) {
      otherPermissionStr = res.otherPermission.toString();
      groupPermissionStr = res.groupPermission.toString();
    }

    var colorScheme = Theme.of(context).colorScheme;

    var titleStyle = const TextStyle(color: Colors.grey, fontSize: 14);
    var valueStyle = TextStyle(color: colorScheme.onPrimaryContainer.withAlpha(190), fontSize: 14);
    return AlertDialog(
      backgroundColor: colorScheme.surface,
      surfaceTintColor: Theme.of(context).colorScheme.surface,
      title: Text(widget.resource.name ?? "未知", style: TextStyle(color: colorScheme.onSurface, fontSize: dialogTitleFontSize)),
      content: SizedBox(
        width: 80,
        height: 245,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 创建时间
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("创建时间", style: titleStyle),
                  Text(DateFormat("yyyy-MM-dd").format(widget.resource.createTime!), style: valueStyle),
                ],
              ),
            ),

            if (groupPermissionStr != null)
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                padding: const EdgeInsets.only(left: 10, right: 2, top: 5, bottom: 2),
                margin: const EdgeInsets.only(top: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("用户组", style: titleStyle),
                        TextButton(
                          onPressed: () {
                            showDialog(
                              barrierDismissible: true,
                              context: context,
                              builder: (BuildContext context) {
                                return SelectGroupDialog(
                                    spaceId: widget.space.id!,
                                    selectGroup: (g) {
                                      // todo 选择组
                                    });
                              },
                            );
                          },
                          child: Text(group.name ?? "未知", style: valueStyle),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("权限", style: titleStyle),
                        DropdownButton<int>(
                          value: groupPermission,
                          elevation: 16,
                          icon: Container(
                            width: 12,
                          ),
                          style: valueStyle,
                          underline: Container(),
                          onChanged: (int? value) {
                            setState(() {
                              groupPermission = value!;
                            });
                          },
                          //需要判断文件还是文件夹，权限可能不同
                          items: const [
                            DropdownMenuItem<int>(
                              value: SpaceFilePermission.readonly,
                              child: Text("可读"),
                            ),
                            DropdownMenuItem<int>(
                              value: SpaceFilePermission.write,
                              child: Text("可写"),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),

            if (otherPermissionStr != null)
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 2),
                margin: const EdgeInsets.only(top: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("其他", style: titleStyle),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("权限", style: titleStyle),
                        DropdownButton<int>(
                          value: otherPermission,
                          elevation: 16,
                          icon: Container(width: 2),
                          style: valueStyle,
                          underline: Container(),
                          onChanged: (int? value) {
                            setState(() {
                              otherPermission = value!;
                            });
                          },
                          //需要判断文件还是文件夹，权限可能不同
                          items: const [
                            DropdownMenuItem<int>(
                              value: SpaceFilePermission.readonly,
                              child: Text("可读"),
                            ),
                            DropdownMenuItem<int>(
                              value: SpaceFilePermission.write,
                              child: Text("可写"),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
      actions: <Widget>[
        CommonActionTwoButton(
          height: 35,
          onLeftTap: () {
            Navigator.pop(context);
          },
          rightTitle: "修改",
          onRightTap: () async {},
        )
      ],
    );
  }
}
