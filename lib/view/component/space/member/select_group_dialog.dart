import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:file_client/model/space/group.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../constant/ui.dart';

class SelectGroupDialog extends StatefulWidget {
  const SelectGroupDialog({super.key});

  @override
  State<SelectGroupDialog> createState() => _SelectGroupDialogState();
}

class _SelectGroupDialogState extends State<SelectGroupDialog> {
  List<Group> _groupList = <Group>[];

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
    return AlertDialog(
      backgroundColor: colorScheme.surface,
      contentPadding: dialogContentPadding,
      title: Text("添加组", style: TextStyle(color: colorScheme.onSurface, fontSize: dialogTitleFontSize)),
      content: Container(
        height: 200,
        width: 100,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(5),
              child: CupertinoSearchTextField(
                style: TextStyle(color: colorScheme.onSurface),
                prefixIcon: Icon(
                  CupertinoIcons.search,
                  color: colorScheme.onSurface,
                ),
                onSubmitted: (value) async {
                  if (value.isEmpty) {
                    return;
                  }
                  try {
                    setState(() {});
                  } on DioException catch (e) {
                    log(e.toString());
                  } catch (e) {
                    log(e.toString());
                  }
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _groupList.length,
                itemBuilder: (BuildContext context, int index) {
                  var group = _groupList[index];
                  //点击后返回当前group
                  return ListTile(
                    key: ValueKey(group.id),
                    onTap: () {
                      Navigator.pop(context, json.encode(group));
                    },
                    title: Text(
                      group.name ?? "",
                      style: TextStyle(color: colorScheme.onSurface),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
