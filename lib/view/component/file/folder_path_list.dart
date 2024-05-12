import 'package:file_client/model/common/common_folder.dart';
import 'package:flutter/material.dart';

import '../../../model/file/user_folder.dart';

class FolderPathList extends StatelessWidget {
  const FolderPathList({
    Key? key,
    required this.folderList,
    this.onTap,
    this.margin,
    this.onCurrentTap,
  }) : super(key: key);

  final List<CommonFolder> folderList;
  final EdgeInsetsGeometry? margin;
  final Function(CommonFolder)? onTap;
  final Function(CommonFolder)? onCurrentTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      height: 30,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          PathItem(
            pathName: "根目录",
            current: folderList.isEmpty,
            onTap: () async {
              if (onTap != null) {
                onTap!(UserFolder.rootFolder());
              }
            },
            onCurrentTap: () {
              if (onCurrentTap != null) {
                onCurrentTap!(UserFolder.rootFolder());
              }
            },
          ),
          ...List.generate(
            folderList.length,
                (index) => PathItem(
              pathName: folderList[index].name!,
              current: index == folderList.length - 1,
              onTap: () async {
                if (onTap != null) {
                  onTap!(folderList[index]);
                }
              },
              onCurrentTap: () {
                if (onCurrentTap != null) {
                  onCurrentTap!(folderList[index]);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class PathItem extends StatelessWidget {
  const PathItem({Key? key, required this.pathName, required this.current, required this.onTap, required this.onCurrentTap}) : super(key: key);

  final String pathName;
  final bool current;
  final Function onTap;
  final Function onCurrentTap;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        InkWell(
          onTap: () {
            if (current) {
              onCurrentTap();
              return;
            }
            onTap();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Row(
              children: [
                Text(
                  pathName,
                  style: current
                      ? TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.primary.withAlpha(190),
                  )
                      : const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (!current)
          Container(
            padding: const EdgeInsets.only(bottom: 3.0),
            child: const Text(
              ">",
              style: TextStyle(color: Colors.grey),
            ),
          ),
      ],
    );
  }
}
