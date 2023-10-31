import 'dart:io';

import 'package:file_client/view/page/account/user_profile_page.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../config/global.dart';
import '../../../model/user/user.dart';
import '../../../service/user/user_service.dart';
import '../../../state/download_state.dart';
import '../../../state/upload_state.dart';
import '../../../state/user_state.dart';

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({Key? key}) : super(key: key);

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  @override
  Widget build(BuildContext context) {
    // var colorScheme = Theme.of(context).colorScheme;
    var userState = Provider.of<UserState>(context);

    var user = userState.user;
    return Navigator(
      onGenerateRoute: (val) {
        return PageRouteBuilder(
          pageBuilder: (BuildContext nContext, Animation<double> animation, Animation<double> secondaryAnimation) {
            return Container(
              color: Theme.of(context).colorScheme.background,
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 3, right: 3, top: 3),
                    height: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Card(
                            margin: const EdgeInsets.all(0),
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                            color: Theme.of(context).colorScheme.surface,
                            child: Container(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      //头像
                                      Container(
                                        margin: const EdgeInsets.only(right: 10),
                                        child: CircleAvatar(
                                          //头像半径
                                          radius: 30,
                                          backgroundImage: user.avatarUrl == null ? null : NetworkImage(user.avatarUrl!),
                                        ),
                                      ),
                                      //信息
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          //名字
                                          Text(
                                            user.name ?? "未登录",
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              color: Theme.of(context).colorScheme.onSurface,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 4.0,
                                          ),
                                          //号码
                                          Text(
                                            "ID: ${user.formatId()}",
                                            style: TextStyle(fontSize: 12.0, color: Theme.of(context).colorScheme.onSurface.withAlpha(100)),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  //
                                  Container(
                                    margin: const EdgeInsets.only(right: 10),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 50,
                                          height: 50,
                                          child: TextButton(
                                            onPressed: () async {
                                              await Navigator.push(nContext, MaterialPageRoute(builder: (context) => const UserProfilePage()));
                                            },
                                            child: Icon(
                                              Icons.edit_note,
                                              size: 30,
                                              color: Theme.of(context).colorScheme.onSurface,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                  //社交信息
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 50.0,
                          margin: const EdgeInsets.only(left: 3.0),
                          height: double.infinity,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          ),
                          clipBehavior: Clip.hardEdge,
                          child: Card(
                            elevation: 0,
                            margin: const EdgeInsets.all(0),
                            color: Theme.of(context).colorScheme.surface,
                            child: TextButton(
                              onPressed: () async {
                                //退出登录
                                await UserService.signOut();
                                //清空用户残留信息
                                if (context.mounted) {
                                  var uploadState = Provider.of<UploadState>(context, listen: false);
                                  uploadState.clearUploadTask();
                                  var downloadState = Provider.of<DownloadState>(context, listen: false);
                                  downloadState.clearDownloadTask();
                                }
                                userState.user = User();
                              },
                              clipBehavior: Clip.hardEdge,
                              child: Icon(
                                Icons.logout_outlined,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                      margin: const EdgeInsets.only(left: 3, right: 3, top: 3),
                      color: Theme.of(context).colorScheme.surface,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
