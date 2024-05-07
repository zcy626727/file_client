import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/user/user.dart';
import '../../state/screen_state.dart';
import '../../state/user_state.dart';
import 'light_dark_switch.dart';

class DesktopSideNavBar extends StatefulWidget {
  const DesktopSideNavBar({Key? key}) : super(key: key);

  @override
  State<DesktopSideNavBar> createState() => _DesktopSideNavBarState();
}

class _DesktopSideNavBarState extends State<DesktopSideNavBar> {
  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    var navState = Provider.of<ScreenNavigatorState>(context);
    return Drawer(
      elevation: 1,
      width: 65,
      backgroundColor: colorScheme.surface,
      child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Container(),
              Expanded(
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(
                        children: [
                          // 头像
                          Container(
                            padding: const EdgeInsets.all(4.0),
                            child: const Center(
                              child: Icon(Icons.cloud, size: 30, color: Colors.blueAccent),
                            ),
                          ),

                          const SizedBox(height: 10.0),
                          SideMenuListTile(
                            iconData: Icons.source,
                            index: FirstNav.file,
                            selectedIndex: navState.firstNavIndex,
                            press: (index) {
                              navState.firstNavIndex = index;
                            },
                          ),
                          const SizedBox(height: 5.0),
                          SideMenuListTile(
                            iconData: Icons.screen_share_rounded,
                            index: FirstNav.share,
                            selectedIndex: navState.firstNavIndex,
                            press: (index) {
                              navState.firstNavIndex = index;
                            },
                          ),
                          const SizedBox(height: 5.0),
                          SideMenuListTile(
                            iconData: Icons.window,
                            index: FirstNav.space,
                            selectedIndex: navState.firstNavIndex,
                            press: (index) {
                              navState.firstNavIndex = index;
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              //用户界面和亮暗模式
              Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                    child: Column(
                      children: [
                        //用户信息
                        SizedBox(
                          height: 45,
                          child: Selector<UserState, User>(
                            selector: (context, userState) => userState.user,
                            shouldRebuild: (pre, next) => pre.id != next.id,
                            builder: (context, user, child) {
                              return OutlinedButton(
                                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.primaryContainer), padding: MaterialStateProperty.all(EdgeInsets.zero)),
                                onPressed: () {
                                  navState.firstNavIndex = FirstNav.account;
                                },
                                child: CircleAvatar(
                                  //头像半径
                                  radius: 30,
                                  backgroundImage: user.avatarUrl == null ? null : NetworkImage(user.avatarUrl!),
                                ),
                              );
                            },
                          ),
                        ),
                        //亮暗模式
                        LightDarkSwitch(isLarge: false),
                      ],
                    ),
                  ),
                ],
              )
            ],
          )),
    );
  }
}

class SideMenuListTile extends StatelessWidget {
  const SideMenuListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.iconData,
    required this.index,
    required this.selectedIndex,
    required this.press,
  }) : super(key: key);

  //当前选中索引
  final int selectedIndex;

  //该项索引
  final int index;

  //展示图标
  final IconData iconData;

  //点击回调
  final Function(int) press;

  @override
  Widget build(BuildContext context) {
    bool isSelected = index == selectedIndex;
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    Color currentColor = isSelected ? colorScheme.onPrimary : colorScheme.onSurface;

    return Container(
      margin: const EdgeInsets.only(top: 3, bottom: 3),
      child: Container(
        height: 40,
        child: Center(
          child: TextButton(
            onPressed: () {
              press(index);
            },
            style: ButtonStyle(
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              )),
              padding: MaterialStateProperty.all(const EdgeInsets.only(top: 17.0, bottom: 20.0)),
              backgroundColor: isSelected ? MaterialStateProperty.all(colorScheme.primary) : null,
            ),
            child: Icon(
              iconData,
              color: currentColor,
              size: 23,
            ),
          ),
        ),
      ),
    );
  }
}
