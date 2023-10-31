import 'package:file_client/view/page/task/download_task_page.dart';
import 'package:file_client/view/page/task/upload_task_page.dart';
import 'package:flutter/material.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({Key? key}) : super(key: key);

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _tabBarBuild(),
          const Expanded(
            child: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: [
                  UploadTaskPage(),
                  DownloadTaskPage(),
                ]),
          )
        ],
      ),
    );
  }


  Widget _tabBarBuild() {
    var colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(top: 5.0, bottom: 5.0,left: 10.0),
      height: 30.0,
      width: 200,
      decoration: BoxDecoration(
        border: Border.all(color: colorScheme.outline, width: 0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: TabBar(
        isScrollable: false,
        //未选择时文字颜色
        unselectedLabelColor: Colors.grey,
        labelColor: colorScheme.onPrimary,
        indicatorSize: TabBarIndicatorSize.tab,
        //指示器样式
        indicator: BoxDecoration(
          //渐变颜色
          color: colorScheme.primary,
          //形状
          borderRadius: BorderRadius.circular(50),
        ),
        splashBorderRadius: BorderRadius.circular(50),
        tabs: <Widget>[
          _tabBuild("上传"),
          _tabBuild("下载"),
        ],
      ),
    );
  }

  Widget _tabBuild(String title) {
    return Tab(
      child: SizedBox(
        child: Align(
          alignment: Alignment.center,
          child: Text(title),
        ),
      ),
    );
  }
}
