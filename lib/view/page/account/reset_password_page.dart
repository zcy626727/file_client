import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../config/constants.dart';
import '../../../service/user/user_service.dart';
import '../../component/show/show_snack_bar.dart';
import '../../widget/common_action_one_button.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key, required this.onUpdated});

  final Function onUpdated;

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();

  String? _newPassword;
  String? _oldPassword;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 50,
        centerTitle: true,
        elevation: 0,
        backgroundColor: colorScheme.surface,
        leading: IconButton(
          splashRadius: 20,
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back,
            color: colorScheme.onBackground,
          ),
        ),
        title: Text(
          "更改密码",
          style: TextStyle(color: colorScheme.onSurface),
        ),
        actions: [],
      ),
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Form(
                key: _formKey,
                child: FocusTraversalGroup(
                  child: Center(
                    child: SizedBox(
                      width: 400,
                      child: Column(
                        children: [
                          const SizedBox(height: 30),
                          oldPasswordBuild(),
                          const SizedBox(height: 30),
                          newPasswordBuild(),
                          const SizedBox(height: 30),
                          confirmPasswordBuild(),
                          const SizedBox(height: 40),
                          CommonActionOneButton(
                            onTap: () async {
                              _formKey.currentState?.save();
                              //执行验证
                              if (_formKey.currentState!.validate()) {
                                try {
                                  await UserService.updatePassword(newPassword: _newPassword!, oldPassword: _oldPassword!);
                                  if (mounted) Navigator.pop(context);
                                  await widget.onUpdated();
                                  //持久化用户信息
                                } on DioException catch (e) {
                                  ShowSnackBar.exception(context: context, e: e, defaultValue: "更改失败");
                                } finally {
                                  Navigator.pop(context);
                                }
                              }
                            },
                            title: "确认",
                            height: 45,
                            textColor: colorScheme.onPrimary,
                            backgroundColor: colorScheme.primary,
                            radius: 20,
                          )
                        ],
                      ),
                    ),
                  )
                )),
          )
        ],
      ),
    );
  }

  TextFormField oldPasswordBuild() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => _oldPassword = newValue,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "密码不能为空";
        } else if (value.length < 8) {
          return "密码长度最小为8";
        }
        return null;
      },
      style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
      decoration: InputDecoration(
        labelText: "原密码",
        labelStyle: TextStyle(color: Theme.of(context).colorScheme.onBackground),
        border: OutlineInputBorder(
          //添加边框
          borderRadius: BorderRadius.circular(30.0),
        ),
        suffixIcon: Icon(
          Icons.password,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      keyboardType: TextInputType.number,
    );
  }

  TextFormField newPasswordBuild() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => _newPassword = newValue,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "密码不能为空";
        } else if (value.length < 8) {
          return "密码长度最小为8";
        }
        return null;
      },
      style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
      decoration: InputDecoration(
        labelText: "新密码",
        labelStyle: TextStyle(color: Theme.of(context).colorScheme.onBackground),
        border: OutlineInputBorder(
          //添加边框
          borderRadius: BorderRadius.circular(30.0),
        ),
        suffixIcon: Icon(
          Icons.password,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      keyboardType: TextInputType.number,
    );
  }

  TextFormField confirmPasswordBuild() {
    return TextFormField(
      obscureText: true,
      validator: (value) {
        if (_newPassword != value) {
          return "两次输入的密码不一致";
        }
        return null;
      },
      style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
      cursorColor: Theme.of(context).colorScheme.onBackground,
      decoration: InputDecoration(
        labelText: "确认密码",
        labelStyle: TextStyle(color: Theme.of(context).colorScheme.onBackground),
        border: OutlineInputBorder(
          //添加边框
          borderRadius: BorderRadius.circular(30.0),
        ),
        suffixIcon: Icon(
          Icons.confirmation_number,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      keyboardType: TextInputType.number,
    );
  }
}
