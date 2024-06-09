import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/file/constant/download.dart';
import '../../../common/file/task/download_task.dart';
import '../../../state/download_state.dart';
import '../../../view/component/task/download_list_view_item.dart';

class DownloadTaskPage extends StatefulWidget {
  const DownloadTaskPage({Key? key}) : super(key: key);

  @override
  State<DownloadTaskPage> createState() => _DownloadTaskPageState();
}

class _DownloadTaskPageState extends State<DownloadTaskPage> {
  @override
  Widget build(BuildContext context) {
    return Selector<DownloadState, DownloadState>(
      selector: (context, data) => data,
      shouldRebuild: (pre, next) => true,
      builder: (context, downloadState, child) {
        var totalTaskList = downloadState.totalTaskList;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            children: [
              _tableTitleBuild(),
              Flexible(
                child: ListView.builder(
                  itemBuilder: (ctx, index) {
                    DownloadTask task = totalTaskList[index];
                    return DownloadListViewItem(
                      onStartOrPause: () {
                        if (task.status == DownloadTaskStatus.downloading) {// 下载中，暂停
                          downloadState.pauseDownloadTask(task);
                        } else if(task.status == DownloadTaskStatus.pause) {// 暂停中，开始下载
                          downloadState.startPauseTask(task);
                        }
                        setState(() {});
                      },
                      onCancel: () {
                        downloadState.removeDownloadTask(task);
                      },
                      task: task,
                    );
                  },
                  itemCount: totalTaskList.length,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _tableTitleBuild() {
    return Column(
      children: [
        const Divider(
          height: 1,
          color: Colors.grey,
        ),
        Container(
          margin: const EdgeInsets.only(top: 7.0, bottom: 7.0),
          child: Row(
            children: [
              const Expanded(
                flex: 1,
                child: Text(
                  "名称",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              const Expanded(
                flex: 1,
                child: Text(
                  "进度",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              const Expanded(
                flex: 1,
                child: Text(
                  "状态",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 10.0),
                width: 100,
                child: const Text(
                  "操作",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
        const Divider(
          height: 1,
          color: Colors.grey,
        ),
      ],
    );
  }
}
