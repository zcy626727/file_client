//所处的各种路径
import 'package:flutter/cupertino.dart';

import '../model/file/user_folder.dart';
import '../model/space/space_folder.dart';

class PathState extends ChangeNotifier {
  List<UserFolder> mainPathList = <UserFolder>[];
  Map<int, List<SpaceFolder>> spacePathMap = {};

  void addMainFolder(UserFolder userFolder) {
    mainPathList.add(userFolder);
    notifyListeners();
  }

  void turnToMainFolder(UserFolder userFolder) {
    while (mainPathList.last.id != userFolder.id) {
      mainPathList.removeLast();
    }
    notifyListeners();
  }

  void clearMainPath() {
    mainPathList.clear();
    notifyListeners();
  }

  List<SpaceFolder> getSpaceFolder({required int spaceId}) {
    if (spacePathMap[spaceId] == null) {
      //为null就先初始化
      spacePathMap[spaceId] = [];
    }
    return spacePathMap[spaceId]!;
  }

  void addSpaceFolder({required int spaceId, required SpaceFolder spaceFolder}) {
    if (spacePathMap[spaceId] == null) {
      //为null就先初始化
      spacePathMap[spaceId] = [];
    }
    spacePathMap[spaceId]!.add(spaceFolder);
    notifyListeners();
  }

  void turnToSpaceFolder({required int spaceId, required SpaceFolder spaceFolder}) {
    var pathList = spacePathMap[spaceId];
    if (pathList == null) return;
    while (pathList.last.id != spaceFolder.id) {
      pathList.removeLast();
      notifyListeners();
    }
  }

  void clearSpacePath(int spaceId) {
    var pathList = spacePathMap[spaceId];
    if (pathList == null) return;
    pathList.clear();
    notifyListeners();
  }
}
