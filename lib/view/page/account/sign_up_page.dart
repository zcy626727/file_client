import 'dart:async';
import 'dart:developer';

import 'package:file_client/view/component/show/show_snack_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../config/constants.dart';
import '../../../service/user/user_service.dart';


class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key, required this.onSignUpSuccess}) : super(key: key);

  //登录后跳转页面使用
  final Function onSignUpSuccess;

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  RegExp phoneExp = RegExp(
      r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$');

  String _phoneNumber = "";
  String _password = "";
  String _confirmPassword = "";
  String _alias = "";
  bool _signUpIng = false;

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
                      child: aliasBuild(),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: loginInputWidth,
                      child: phoneNumBuild(),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: loginInputWidth,
                      child: passwordBuild(),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: loginInputWidth,
                      child: confirmPasswordBuild(),
                    ),
                    const SizedBox(height: 40),
                    signUpButtonBuild(),
                  ],
                ),
              )),
        )
      ],
    );
  }

  TextFormField aliasBuild() {
    return TextFormField(
      onSaved: (newValue) => _alias = newValue!,
      validator: (value) {
        if (value!.isEmpty) {
          return "随便起一个吧";
        } else if (value.length > 20) {
          return "太长也不好";
        }
        return null;
      },
      style: TextStyle(color: Theme
          .of(context)
          .colorScheme
          .onBackground),
      decoration: InputDecoration(
        labelText: "名字",
        labelStyle:
        TextStyle(color: Theme
            .of(context)
            .colorScheme
            .onBackground),
        hintText: "名字",
        hintStyle: TextStyle(
            color: Theme
                .of(context)
                .colorScheme
                .onBackground
                .withAlpha(150)),
        border: OutlineInputBorder(
          //添加边框
          borderRadius: BorderRadius.circular(30.0),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(
          Icons.person,
          color: Theme
              .of(context)
              .colorScheme
              .primary,
        ),
      ),
      keyboardType: TextInputType.number,
    );
  }

  TextFormField phoneNumBuild() {
    return TextFormField(
      onSaved: (newValue) => _phoneNumber = newValue!,
      validator: (value) {
        if (value!.isEmpty) {
          return "手机号不能为空";
        } else if (!phoneExp.hasMatch(value)) {
          return "手机号格式有误";
        }
        return null;
      },
      style: TextStyle(color: Theme
          .of(context)
          .colorScheme
          .onBackground),
      decoration: InputDecoration(
        labelText: "账号",
        labelStyle:
        TextStyle(color: Theme
            .of(context)
            .colorScheme
            .onBackground),
        hintText: "手机号",
        hintStyle: TextStyle(
            color: Theme
                .of(context)
                .colorScheme
                .onBackground
                .withAlpha(150)),
        border: OutlineInputBorder(
          //添加边框
          borderRadius: BorderRadius.circular(30.0),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(
          Icons.person,
          color: Theme
              .of(context)
              .colorScheme
              .primary,
        ),
      ),
      keyboardType: TextInputType.number,
    );
  }

  TextFormField passwordBuild() {
    return TextFormField(
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
      style: TextStyle(color: Theme
          .of(context)
          .colorScheme
          .onBackground),
      decoration: InputDecoration(
        labelText: "密码",
        labelStyle:
        TextStyle(color: Theme
            .of(context)
            .colorScheme
            .onBackground),
        hintText: "密码",
        hintStyle: TextStyle(
            color: Theme
                .of(context)
                .colorScheme
                .onBackground
                .withAlpha(150)),
        border: OutlineInputBorder(
          //添加边框
          borderRadius: BorderRadius.circular(30.0),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(
          Icons.password,
          color: Theme
              .of(context)
              .colorScheme
              .primary,
        ),
      ),
      keyboardType: TextInputType.number,
    );
  }

  TextFormField confirmPasswordBuild() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => _confirmPassword = newValue!,
      validator: (value) {
        if (_password != value) {
          return "两次输入的密码不一致";
        }
        return null;
      },
      style: TextStyle(color: Theme
          .of(context)
          .colorScheme
          .onBackground),
      cursorColor: Theme
          .of(context)
          .colorScheme
          .onBackground,
      decoration: InputDecoration(
        labelText: "确认密码",
        labelStyle:
        TextStyle(color: Theme
            .of(context)
            .colorScheme
            .onBackground),
        hintText: "确认密码",
        hintStyle: TextStyle(
            color: Theme
                .of(context)
                .colorScheme
                .onBackground
                .withAlpha(150)),
        border: OutlineInputBorder(
          //添加边框
          borderRadius: BorderRadius.circular(30.0),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(
          Icons.confirmation_number,
          color: Theme
              .of(context)
              .colorScheme
              .primary,
        ),
      ),
      keyboardType: TextInputType.number,
    );
  }

  signUpButtonBuild() {
    ColorScheme colorScheme = Theme
        .of(context)
        .colorScheme;
    return SizedBox(
        height: 46,
        width: loginInputWidth,
        child: TextButton(
          style: ButtonStyle(
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              )),
              backgroundColor: MaterialStateProperty.all(
                  _signUpIng ? Colors.blue.withAlpha(150) : Colors.blue)),
          onPressed: _signUpIng
              ? null
              : () {
            _formKey.currentState?.save();
            //执行验证
            if (_formKey.currentState!.validate()) {
              //加载
              setState(() {
                _signUpIng = true;
              });
              //执行验证
              signUp();
            }
          },
          child: _signUpIng
              ? CupertinoActivityIndicator(color: colorScheme.onSurface)
              : const Text(
            "注册",
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ));
  }

  signUp() async {
    try {
      //发送注册请求
      await UserService.signUp(_phoneNumber, _password, _alias);
      widget.onSignUpSuccess();
      log("注册成功");
    } on TimeoutException catch (e) {
      ShowSnackBar.error(context: context, message: "请求超时");
    } on Exception catch (e) {
      ShowSnackBar.exception(context: context, e: e, defaultValue: "注册失败");
    } finally {
      setState(() {
        _signUpIng = false;
      });
    }
  }
}
