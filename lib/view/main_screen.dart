import 'package:file_client/view/screen/share_screen.dart';
import 'package:file_client/view/screen/space_screen.dart';
import 'package:file_client/view/screen/task_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/screen_state.dart';
import '../state/user_state.dart';
import '../util/responsive.dart';
import 'component/desktop_side_nav_bar.dart';
import 'page/account/account_page.dart';
import 'screen/file_screen.dart';

//主界面，负责处理布局、加载配置
class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MainScreenState();
  }
}

class MainScreenState extends State<MainScreen> {
  // final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      drawerEnableOpenDragGesture: false,
      body: Container(
        color: colorScheme.surface,
        child: Row(
          children: [
            //左侧菜单栏
            if (!Responsive.isSmallWithDevice(context))
              const DesktopSideNavBar(),
            //主界面
            Expanded(
              flex: 5,
              //适配不规则屏幕（刘海屏）
              child: SafeArea(
                child: _body(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar:
          Responsive.isSmallWithDevice(context) ? _bottomNav() : null,
    );
  }

  Widget _bottomNav() {
    var navState = Provider.of<ScreenNavigatorState>(context, listen: false);
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: '文件',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.explore_outlined),
          label: '分享',
        ),
      ],
      currentIndex: navState.firstNavIndex,
      onTap: (index) {
        navState.firstNavIndex = index;
      },
      type: BottomNavigationBarType.fixed,
      backgroundColor: colorScheme.surface,
      unselectedItemColor: Colors.grey,
      selectedItemColor: colorScheme.primary,
    );
  }

  Widget _body() {
    return SafeArea(
      child: Container(
        child:
            _getPage(Provider.of<ScreenNavigatorState>(context).firstNavIndex),
      ),
    );
  }

  Widget _getPage(int index) {
    var userState = Provider.of<UserState>(context);
    if (!userState.isLogin) {
      return const DesktopAccountScreen();
    }
    switch (index) {
      case FirstNav.share:
        return const ShareScreen();
      case FirstNav.account:
        return const DesktopAccountScreen();
      case FirstNav.space:
        return const SpaceScreen();
      case FirstNav.file:
        return const FileScreen();
      case FirstNav.task:
        return const TaskScreen();
      default:
        return Container();
    }
  }
}
