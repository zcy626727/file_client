import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:file_client/constant/file.dart';
import 'package:file_client/model/common/common_resource.dart';
import 'package:file_client/model/space/group.dart';
import 'package:file_client/model/space/space_file.dart';
import 'package:file_client/model/space/space_folder.dart';
import 'package:file_client/service/team/group_service.dart';
import 'package:file_client/service/team/space_file_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../constant/space.dart';
import '../../../constant/ui.dart';
import '../../widget/common_action_two_button.dart';
import '../show/show_snack_bar.dart';
import '../space/member/select_group_dialog.dart';

class SpaceDetailDialog extends StatefulWidget {
  const SpaceDetailDialog({super.key, required this.spaceResource, required this.onUpdate});

  final CommonResource spaceResource;
  final Function(int? newGroupId, int? newGroupPermission, int? newOtherPermission) onUpdate;

  @override
  State<SpaceDetailDialog> createState() => _SpaceDetailDialogState();
}

class _SpaceDetailDialogState extends State<SpaceDetailDialog> {
  Group? _selectedGroup;
  int? _otherPermission;
  int? _groupPermission;
  int? spaceId;

  late Future _futureBuilderFuture;

  Future<void> loadPermission() async {
    try {
      var res = widget.spaceResource;
      if (res is SpaceFile) {
        if (res.groupId != null) {
          _selectedGroup = await GroupService.getGroupById(groupId: res.groupId!);
          _groupPermission = res.groupPermission;
        }
        _otherPermission = res.otherPermission;
        spaceId = res.spaceId;
      } else if (res is SpaceFolder) {
        if (res.groupId != null) {
          _selectedGroup = await GroupService.getGroupById(groupId: res.groupId!);
          _groupPermission = res.groupPermission;
        }
        _otherPermission = res.otherPermission;
        spaceId = res.spaceId;
      }
    } on DioException catch (e) {
      log(e.toString());
    } catch (e) {
      log(e.toString());
    }
  }

  Future getData() async {
    return Future.wait([loadPermission()]);
  }

  @override
  void initState() {
    super.initState();
    _futureBuilderFuture = getData();
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    var titleStyle = const TextStyle(color: Colors.grey, fontSize: 14);
    var valueStyle = TextStyle(color: colorScheme.onSurface, fontSize: 14);
    return FutureBuilder(
      future: _futureBuilderFuture,
      builder: (BuildContext context, AsyncSnapshot snapShot) {
        if (snapShot.connectionState == ConnectionState.done) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: AlertDialog(
              insetPadding: const EdgeInsets.all(10),
              backgroundColor: colorScheme.background,
              surfaceTintColor: Theme.of(context).colorScheme.surface,
              title: Text(widget.spaceResource.name ?? "————", style: TextStyle(color: colorScheme.onSurface, fontSize: dialogTitleFontSize)),
              content: SizedBox(
                width: 300,
                height: 330,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // 创建时间
                    Container(
                      height: 70,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                      ),
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text("创建时间", style: titleStyle),
                          Text(DateFormat("yyyy-MM-dd").format(widget.spaceResource.createTime!), style: valueStyle),
                        ],
                      ),
                    ),

                    // 组
                    Container(
                      height: 101,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 10),
                            height: 50,
                            child: Row(
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
                                          buttonTitle: "清空用户组",
                                          spaceId: spaceId!,
                                          selectGroup: (g) {
                                            _selectedGroup = g;
                                            setState(() {});
                                          },
                                        );
                                      },
                                    );
                                  },
                                  style: ButtonStyle(padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 10))),
                                  child: SizedBox(
                                    // width: 70,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.only(left: 5),
                                          child: Text(_selectedGroup?.name ?? "未分配", style: valueStyle),
                                        ),
                                        Icon(Icons.arrow_drop_down, color: colorScheme.onSurface),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(height: 1, color: colorScheme.background),
                          Container(
                            margin: const EdgeInsets.only(left: 10, right: 10),
                            height: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("权限", style: titleStyle),
                                DropdownButton<int?>(
                                  value: _groupPermission,
                                  alignment: AlignmentDirectional.centerEnd,
                                  elevation: 16,
                                  style: valueStyle,
                                  underline: Container(),
                                  icon: Icon(Icons.arrow_drop_down, color: colorScheme.onSurface),
                                  onChanged: (int? value) {
                                    setState(() {
                                      _groupPermission = value;
                                    });
                                  },
                                  items: [
                                    const DropdownMenuItem<int?>(
                                      value: null,
                                      child: Text("未分配"),
                                    ),
                                    // 文件夹
                                    if (widget.spaceResource.fileType == FileType.direction)
                                      ...List.generate(
                                        SpaceFilePermission.folderPermissionList.length,
                                        (index) {
                                          var (key, str) = SpaceFilePermission.folderPermissionList[index];
                                          return DropdownMenuItem<int>(
                                            value: key,
                                            child: Text(str),
                                          );
                                        },
                                      ),
                                    if (widget.spaceResource.fileType != FileType.direction)
                                      ...List.generate(
                                        SpaceFilePermission.filePermissionList.length,
                                        (index) {
                                          var (key, str) = SpaceFilePermission.filePermissionList[index];
                                          return DropdownMenuItem<int>(
                                            value: key,
                                            child: Text(str),
                                          );
                                        },
                                      ),
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),

                    // 其他人权限
                    Container(
                      width: double.infinity,
                      height: 101,
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            height: 50,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text("其他", style: titleStyle),
                            ),
                          ),
                          Divider(height: 1, color: colorScheme.background),
                          Container(
                            height: 50,
                            margin: const EdgeInsets.only(left: 10, right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("权限", style: titleStyle),
                                DropdownButton<int?>(
                                  value: _otherPermission,
                                  elevation: 16,
                                  icon: Icon(Icons.arrow_drop_down, color: colorScheme.onSurface),
                                  alignment: AlignmentDirectional.centerEnd,
                                  style: valueStyle,
                                  underline: Container(),
                                  onChanged: (int? value) {
                                    setState(() {
                                      _otherPermission = value;
                                    });
                                  },
                                  items: [
                                    const DropdownMenuItem<int?>(
                                      value: null,
                                      child: Text("未分配"),
                                    ),
                                    // 文件夹
                                    if (widget.spaceResource.fileType == FileType.direction)
                                      ...List.generate(
                                        SpaceFilePermission.folderPermissionList.length,
                                        (index) {
                                          var (key, str) = SpaceFilePermission.folderPermissionList[index];
                                          return DropdownMenuItem<int>(
                                            value: key,
                                            child: Text(str),
                                          );
                                        },
                                      ),
                                    if (widget.spaceResource.fileType != FileType.direction)
                                      ...List.generate(
                                        SpaceFilePermission.filePermissionList.length,
                                        (index) {
                                          var (key, str) = SpaceFilePermission.filePermissionList[index];
                                          return DropdownMenuItem<int>(
                                            value: key,
                                            child: Text(str),
                                          );
                                        },
                                      ),
                                  ],
                                )
                              ],
                            ),
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
                  onRightTap: () async {
                    try {
                      if (widget.spaceResource.id == null) throw const FormatException("文件信息错误");
                      await SpaceFileService.updatePermission(
                        spaceFileId: widget.spaceResource.id!,
                        newGroupId: _selectedGroup?.id,
                        newGroupPermission: _groupPermission,
                        newOtherPermission: _otherPermission,
                      );
                      widget.onUpdate(_selectedGroup?.id, _groupPermission, _otherPermission);
                      if (context.mounted) Navigator.pop(context);
                    } on Exception catch (e) {
                      if (context.mounted) ShowSnackBar.exception(context: context, e: e);
                    }
                  },
                )
              ],
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
