import 'package:flutter/cupertino.dart';

//界面状态
class ScreenNavigatorState extends ChangeNotifier {
  //桌面索引
  int _firstNav = FirstNav.file;
  int _secondNav = SecondNav.resourcePlaza;

  int get firstNavIndex {
    return _firstNav;
  }

  int get secondNavIndex {
    return _secondNav;
  }

  set firstNavIndex(int firstNav) {
    switch (firstNav) {
      case FirstNav.file:
        _secondNav = SecondNav.workspace;
        break;
      case FirstNav.share:
        _secondNav = SecondNav.resourcePlaza;
        break;
    }
    _firstNav = firstNav;
    notifyListeners();
  }

  set secondNavIndex(int secondNav) {
    //一级标题
    switch (secondNav) {
      case SecondNav.workspace:
      case SecondNav.task:
      case SecondNav.trash:
        _firstNav = FirstNav.file;
        break;
      case SecondNav.linkShare:
        _firstNav = FirstNav.share;
        break;
    }
    _secondNav = secondNav;
    notifyListeners();
  }
}

class FirstNav {
  static const int file = 0;
  static const int share = 1;
  static const int account = 3;
}

class SecondNav {
  //file
  static const int workspace = 0;
  static const int task = 1;
  static const int trash = 2;

  //share
  static const int resourcePlaza = 3;

  static const int linkShare = 4;
  static const int topicShare = 5;
  static const int albumShare = 6;

  static const int topicSubscribe = 7;
  static const int albumSubscribe = 8;
}
