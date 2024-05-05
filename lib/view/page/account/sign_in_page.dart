import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../config/constants.dart';
import '../../../model/user/user.dart';
import '../../../service/user/user_service.dart';
import '../../../state/download_state.dart';
import '../../../state/upload_state.dart';
import '../../../state/user_state.dart';
import '../../component/show/show_snack_bar.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();

  RegExp phoneExp = RegExp(r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$');

  String _phoneNumber = "";
  String _password = "";
  bool _signInIng = false;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Form(
            key: _formKey,
            child: FocusTraversalGroup(
              child: Column(
                children: [
                  const SizedBox(height: 30.0),
                  SizedBox(
                    width: loginInputWidth,
                    child: phoneNumBuild(),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: loginInputWidth,
                    child: passwordBuild(),
                  ),
                  const SizedBox(height: 40),
                  signInButtonBuild(),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  TextFormField phoneNumBuild() {
    return TextFormField(
      initialValue: _phoneNumber,
      onSaved: (newValue) => _phoneNumber = newValue!,
      validator: (value) {
        if (value!.isEmpty) {
          return "手机号不能为空";
        } else if (!phoneExp.hasMatch(value)) {
          return "手机号格式有误";
        }
        return null;
      },
      style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
      decoration: InputDecoration(
        labelText: "账号",
        labelStyle: TextStyle(color: Theme.of(context).colorScheme.onBackground),
        hintText: "手机号",
        hintStyle: TextStyle(color: Theme.of(context).colorScheme.onBackground.withAlpha(150)),
        border: OutlineInputBorder(
          //添加边框
          borderRadius: BorderRadius.circular(30.0),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(
          Icons.person,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      keyboardType: TextInputType.number,
    );
  }

  TextFormField passwordBuild() {
    return TextFormField(
      initialValue: _password,
      obscureText: true,
      onSaved: (newValue) => _password = newValue!,
      validator: (value) {
        if (value!.isEmpty) {
          return "密码不能为空";
        } else if (value.length < 8) {
          return "密码长度最小为8";
        }
        return null;
      },
      style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
      decoration: InputDecoration(
        labelText: "密码",
        labelStyle: TextStyle(color: Theme.of(context).colorScheme.onBackground),
        hintText: "密码",
        hintStyle: TextStyle(color: Theme.of(context).colorScheme.onBackground.withAlpha(150)),
        border: OutlineInputBorder(
          //添加边框
          borderRadius: BorderRadius.circular(30.0),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(
          Icons.password,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      keyboardType: TextInputType.number,
    );
  }

  signInButtonBuild() {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Selector<UserState, UserState>(
      selector: (context, userState) => userState,
      shouldRebuild: (pre, next) => false,
      builder: (context, userState, child) {
        return SizedBox(
          height: 46,
          width: loginInputWidth,
          child: TextButton(
            style: ButtonStyle(
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                )),
                //登录中为灰色
                backgroundColor: MaterialStateProperty.all(_signInIng ? Colors.blue.withAlpha(150) : Colors.blue)),
            //登录中不可点击
            onPressed: _signInIng
                ? null
                : () async {
                    _formKey.currentState?.save();
                    //执行验证
                    if (_formKey.currentState!.validate()) {
                      //加载
                      setState(() {
                        _signInIng = true;
                      });
                      //
                      await signIn(userState);
                    }
                  },
            child: _signInIng
                ? CupertinoActivityIndicator(color: colorScheme.onSurface)
                : const Text(
                    "登录",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
          ),
        );
      },
    );
  }

  //登录
  signIn(UserState userState) async {
    //发送请求
    try {
      User user = await UserService.signIn(_phoneNumber, _password).timeout(const Duration(seconds: 2));
      //赋值给全局变量
      userState.user = user;
      if (context.mounted) {
        var uploadState = Provider.of<UploadState>(context, listen: false);
        uploadState.initUploadTask();
        var downloadState = Provider.of<DownloadState>(context, listen: false);
        downloadState.initDownloadTask();
      }
    } on TimeoutException catch (e) {
      if (mounted) ShowSnackBar.error(context: context, message: "请求超时");
    } on Exception catch (e) {
      if (mounted) ShowSnackBar.exception(context: context, e: e, defaultValue: "登录失败");
    } finally {
      setState(() {
        _signInIng = false;
      });
    }
  }
}
