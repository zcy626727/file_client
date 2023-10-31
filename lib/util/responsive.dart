import 'package:flutter/material.dart';

import 'device.dart';

/// 响应式布局
class Responsive extends StatelessWidget {
  //小屏幕:手机
  final Widget small;

  //中等屏幕:平板
  final Widget medium;

  //大屏幕:电脑
  final Widget large;

  //创建时只需要传递不同尺寸时需要展示的Widget，flutter会自动调用build方法返回合适的Widget
  const Responsive({
    Key? key,
    required this.small,
    required this.medium,
    required this.large,
  }) : super(key: key);

  // 界面的大小范围
  static bool isSmall(BuildContext context) => MediaQuery.of(context).size.width < 850;

  static bool isMedium(BuildContext context) => MediaQuery.of(context).size.width < 1100 && MediaQuery.of(context).size.width >= 850;

  static bool isLarge(BuildContext context) => MediaQuery.of(context).size.width >= 1100;

  static bool isSmallWithDevice(BuildContext context) => Device.isMobileDevice || (Device.isWeb && isSmall(context));

  static bool isLargeWithDevice(BuildContext context) => Device.isDesktopDevice || (Device.isWeb && isLarge(context));

  @override
  Widget build(BuildContext context) {
    //获取可用界面空间
    final Size size = MediaQuery.of(context).size;
    //大于 1100 则为 large
    if (size.width >= 1100) {
      return large;
    }
    //在 1100 和 850 之间则为 medium
    else if (size.width >= 850) {
      return medium;
    }
    //850 之下的算作 small
    else {
      return small;
    }
  }
}
