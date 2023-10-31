import 'package:file_client/view/page/account/sign_in_or_up_page.dart';
import 'package:file_client/view/page/account/user_info_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../../model/user/user.dart';
import '../../../state/user_state.dart';

class DesktopAccountScreen extends StatefulWidget {
  const DesktopAccountScreen({Key? key}) : super(key: key);

  @override
  State<DesktopAccountScreen> createState() => _DesktopAccountScreenState();
}

class _DesktopAccountScreenState extends State<DesktopAccountScreen> {
  @override
  Widget build(BuildContext context) {
    //如果未登录转到登录页
    return Selector<UserState, User>(
      selector: (context, userState) => userState.user,
      shouldRebuild: (pre, next) => pre.token != next.token,
      builder: (context, user, child) {
        //未登录，显示登录注册界面
        if(user.token==null){
          return const SignInOrUpPage();
        }else{
          return const UserInfoPage();
        }

      },
    );
  }


}
