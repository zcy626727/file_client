import 'package:file_client/view/page/file/trash_page.dart';
import 'package:file_client/view/page/task/task_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/screen_state.dart';
import '../page/file/workspace_page.dart';
import '../widget/desktop_nav_button.dart';

class FileScreen extends StatefulWidget {
  const FileScreen({Key? key}) : super(key: key);

  @override
  State<FileScreen> createState() => _FileScreenState();
}

class _FileScreenState extends State<FileScreen> {
  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var navState = Provider.of<ScreenNavigatorState>(context, listen: true);
    return Row(
      children: [
        Container(
          color: colorScheme.surface,
          width: 180,
          child: Row(
            children: [
              VerticalDivider(color: Colors.grey.withAlpha(100), width: 1),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NavButton(
                      title: "我的文件",
                      iconData: Icons.folder,
                      onPress: () {
                        navState.secondNavIndex = SecondNav.workspace;
                      },
                      index: SecondNav.workspace,
                      selectedIndex: navState.secondNavIndex,
                    ),
                    NavButton(
                      title: "任务列表",
                      iconData: Icons.task,
                      onPress: () {
                        navState.secondNavIndex = SecondNav.task;
                      },
                      index: SecondNav.task,
                      selectedIndex: navState.secondNavIndex,
                    ),
                    NavButton(
                      title: "回收站",
                      iconData: Icons.delete,
                      onPress: () {
                        navState.secondNavIndex = SecondNav.trash;
                      },
                      index: SecondNav.trash,
                      selectedIndex: navState.secondNavIndex,
                    ),
                    // Container(
                    //   margin: const EdgeInsets.only(left: 10.0, top: 8.0, bottom: 8.0),
                    //   child: const Text("媒体", style: TextStyle(color: Colors.grey, fontSize: 12)),
                    // ),
                  ],
                ),
              ),
              VerticalDivider(color: Colors.grey.withAlpha(100), width: 1),
            ],
          ),
        ),
        Expanded(
          child: _getPage(navState.secondNavIndex),
        ),
      ],
    );
  }

  Widget _getPage(int index) {
    switch (index) {
      case SecondNav.workspace:
        return const WorkspacePage();
      case SecondNav.task:
        return const TaskPage();
      case SecondNav.trash:
        return const TrashPage();
      default:
        return Container();
    }
  }
}
