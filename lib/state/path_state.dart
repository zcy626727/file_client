//所处的各种路径
import 'package:flutter/cupertino.dart';

import '../model/file/user_folder.dart';


class PathState extends ChangeNotifier{

  List<UserFolder> workplaceFolderList = <UserFolder>[];

  void appendWorkspacePlace(UserFolder userFolder){
    workplaceFolderList.add(userFolder);
    notifyListeners();
  }

  void turnToWorkspacePlace(UserFolder userFolder){
    while(workplaceFolderList.last.id!=userFolder.id){
      workplaceFolderList.removeLast();
    }
    notifyListeners();
  }

  void clearWorkspacePlace(){
    workplaceFolderList.clear();
    notifyListeners();
  }
}