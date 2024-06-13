import 'package:file_client/model/space/group.dart';
import 'package:file_client/service/team/group_service.dart';
import 'package:file_client/view/widget/common_action_one_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../common/list/common_item_list.dart';
import '../../../../constant/ui.dart';

class SelectGroupDialog extends StatefulWidget {
  const SelectGroupDialog({super.key, required this.spaceId, required this.selectGroup, this.buttonTitle = "返回"});

  final int spaceId;
  final String buttonTitle;
  final Function(Group?) selectGroup;

  @override
  State<SelectGroupDialog> createState() => _SelectGroupDialogState();
}

class _SelectGroupDialogState extends State<SelectGroupDialog> {
  String? _searchKeyword;

  @override
  void initState() {
    super.initState();
  }

  Future getData() async {
    return Future.wait([]);
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return AlertDialog(
      backgroundColor: colorScheme.surface,
      surfaceTintColor: Theme.of(context).colorScheme.surface,
      contentPadding: dialogContentPadding,
      title: Text("选择组", style: TextStyle(color: colorScheme.onSurface, fontSize: dialogTitleFontSize)),
      content: SizedBox(
        height: 200,
        width: 100,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(5),
              child: CupertinoSearchTextField(
                autofocus: true,
                style: TextStyle(color: colorScheme.onSurface),
                prefixIcon: Icon(
                  CupertinoIcons.search,
                  color: colorScheme.onSurface,
                ),
                onSubmitted: (value) async {
                  if (value.isEmpty) return;
                  _searchKeyword = value;
                  setState(() {});
                },
              ),
            ),
            Expanded(
              child: CommonItemList<Group>(
                onLoad: (int page) async {
                  if (_searchKeyword == null) return <Group>[];
                  var list = await GroupService.searchSpaceGroupList(keyword: _searchKeyword!, spaceId: widget.spaceId, pageIndex: page).timeout(const Duration(seconds: 2));
                  return list;
                },
                key: ValueKey(_searchKeyword),
                itemName: "空间",
                itemHeight: null,
                enableScrollbar: false,
                itemBuilder: (ctx, item, itemList, onFresh) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 5),
                    child: TextButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(colorScheme.primaryContainer),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      onPressed: () {
                        widget.selectGroup(item);
                        Navigator.pop(context);
                      },
                      child: ListTile(
                        key: ValueKey(item.id),
                        title: Text(
                          item.name ?? "——",
                          style: TextStyle(color: colorScheme.onSurface),
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
      actions: [
        CommonActionOneButton(
          onTap: () {
            Navigator.pop(context);
            widget.selectGroup(null);
          },
          title: "选择空组",
        )
      ],
    );
  }
}
