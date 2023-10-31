import 'dart:ui';

import 'package:flutter/material.dart';

import '../config/global.dart';
import '../model/user/user.dart';

//用户相关状态
class UserState extends ChangeNotifier{
  User get user => Global.user;

  // APP是否登录(如果有用户信息，则证明登录过)
  bool get isLogin => user.phoneNumber != null;

  //切换用户时需要传递一个新的user对象
  set user(User newUser) {
    Global.user = newUser;
    notifyListeners();
  }
  void notify() {
    notifyListeners();
  }

  //获取当前是暗模式还是亮模式
  Brightness get currentBrightness{
    switch(Global.user.themeMode){
      case 1:
        return Brightness.light;
      case 2:
        return Brightness.dark;
      default:
        return window.platformBrightness;
    }
  }

  //获取当前主题模式：亮、暗、跟随系统
  ThemeMode get currentMode{
    switch(Global.user.themeMode){
      case 1:
        return ThemeMode.light;
      case 2:
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  //设置亮暗模式
  set currentBrightness(Brightness value) {
    if(value == Brightness.light){
      Global.user.themeMode = 1;
    }else if(value == Brightness.dark){
      Global.user.themeMode = 2;
    }
    notifyListeners();
  }


}