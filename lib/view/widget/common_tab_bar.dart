import 'package:flutter/material.dart';

class CommonTabBar extends StatefulWidget {
  const CommonTabBar({Key? key, required this.titleTextList, this.trailing})
      : super(key: key);

  final List<String> titleTextList;
  final Widget? trailing;

  @override
  State<CommonTabBar> createState() => _CommonTabBarState();
}

class _CommonTabBarState extends State<CommonTabBar> {
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Container(
      height: 35,
      width: double.infinity,
      color: colorScheme.surface,
      margin: const EdgeInsets.only(top: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: TabBar(
              onTap: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              //指示器大小设置为和label一致
              indicatorSize: TabBarIndicatorSize.label,
              //启动滚动
              isScrollable: true,
              //未选中内容颜色
              unselectedLabelColor: Colors.grey,
              //选中内容颜色
              labelColor: colorScheme.primary,
              //label间距
              labelPadding: const EdgeInsets.symmetric(horizontal: 3.0),
              tabs: <Widget>[
                ...List.generate(
                  widget.titleTextList.length,
                  (index) => tabBuild(index, widget.titleTextList[index]),
                )
              ],
            ),
          ),
          if (widget.trailing != null) widget.trailing!,
        ],
      ),
    );
  }

  Tab tabBuild(int index, String title) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Tab(
      iconMargin: EdgeInsets.zero,
      child: Container(
        margin: const EdgeInsets.only(left: 20.0,right: 20.0),
        //高度会自动填充剩余部分，设置宽度以保证背景圆形
        child: Center(
          child: Text(title),
        ),
      ),
    );
  }
}
