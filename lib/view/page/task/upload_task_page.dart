import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/upload/constant/upload.dart';
import '../../../common/upload/task/multipart_upload_task.dart';
import '../../../state/upload_state.dart';
import '../../component/task/upload_list_view_item.dart';

class UploadTaskPage extends StatefulWidget {
  const UploadTaskPage({Key? key}) : super(key: key);

  @override
  State<UploadTaskPage> createState() => _UploadTaskPageState();
}

class _UploadTaskPageState extends State<UploadTaskPage> {
  @override
  Widget build(BuildContext context) {
    return Selector<UploadState, UploadState>(
      selector: (context, data) => data,
      shouldRebuild: (pre, next) => true,
      builder: (context, uploadState, child) {
        var totalTaskList = uploadState.totalTaskList;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            children: [
              _tableTitleBuild(),
              Flexible(
                child: ListView.builder(
                  itemBuilder: (ctx, index) {
                    MultipartUploadTask task = totalTaskList[index];
                    return UploadListViewItem(
                      onStartOrPause: () {
                        if (task.status == UploadTaskStatus.uploading ||
                            task.status == UploadTaskStatus.awaiting) {
                          uploadState.pauseUploadTask(task);
                        } else {
                          uploadState.startPauseTask(task);
                        }
                        setState(() {});
                      },
                      onCancel: () {
                        uploadState.removeUploadTask(task);
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
