import 'dart:developer';

import 'package:file_client/view/page/account/sign_in_or_up_page.dart';
import 'package:file_client/view/main_screen.dart';
import 'package:file_client/state/download_state.dart';
import 'package:file_client/state/path_state.dart';
import 'package:file_client/state/screen_state.dart';
import 'package:file_client/state/upload_state.dart';
import 'package:file_client/state/user_state.dart';
import 'package:file_client/theme/color_schemes.g.dart';
import 'package:file_client/view/widget/confirm_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'config/global.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  //初始化全局变量后启动项目
  Global.init().then((e) => runApp(MultiProvider(
          //声明全局状态信息
          providers: [
            //用户状态
            ChangeNotifierProvider(create: (ctx) => UserState()),
            ChangeNotifierProvider(create: (ctx) => ScreenNavigatorState()),
            ChangeNotifierProvider(create: (ctx) => UploadState()),
            ChangeNotifierProvider(create: (ctx) => DownloadState()),
            ChangeNotifierProvider(create: (ctx) => PathState()),
          ],
          child: const MyApp())));
}

//初始化app：读取数据
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future _futureBuilderFuture;

  @override
  void initState() {
    _futureBuilderFuture = init(context);
    super.initState();
  }

  Future<String?> init(BuildContext context) async {
    String? message = await Global.openDBAndInitData();
    // 获取当前用户的上传下载任务
    if (context.mounted) {
      var uploadState = Provider.of<UploadState>(context, listen: false);
      uploadState.initUploadTask();
      var downloadState = Provider.of<DownloadState>(context, listen: false);
      downloadState.initDownloadTask();
    }
    return message;
  }

  @override
  Widget build(BuildContext context) {
    Future<bool> onWillPop() async {
      return await showDialog(
        context: context,
        builder: (context) {
          return ConfirmAlertDialog(
            text: "是否删除",
            onConfirm: () {
              Navigator.of(context).pop(false);
            },
            onCancel: () {
              Navigator.of(context).pop(true);
            },
          );
        },
      );
    }

    log("app构建");
    return FutureBuilder(
        future: _futureBuilderFuture,
        builder: (BuildContext context, AsyncSnapshot snapShot) {
          if (snapShot.connectionState == ConnectionState.done) {
            //有错误信息
            if (snapShot.hasData) {
              log("错误信息：${snapShot.data.toString()}");
            }
            return Selector<UserState, ThemeMode>(
              selector: (context, userState) => userState.currentMode,
              //主题改变时才需要更新所有ui
              //只是用户信息改变了的话只需要更改用户信息相关的ui
              shouldRebuild: (pre, next) => pre != next,
              builder: (context, currentThemeMode, child) {
                log("更新全局ui");
                return WillPopScope(
                  onWillPop: onWillPop,
                  child: MaterialApp(
                    debugShowCheckedModeBanner: false,
                    title: "file",
                    //正常模式主题
                    theme: Theme.of(context).copyWith(
                      brightness: Brightness.light,
                      colorScheme: lightColorScheme,
                    ),
                    //暗模式主题
                    darkTheme: Theme.of(context).copyWith(
                      brightness: Brightness.light,
                      colorScheme: darkColorScheme,
                    ),
                    routes: {
                      "login": (context) => const SignInOrUpPage(),
                    },
                    //全局状态获取主题模式
                    themeMode: currentThemeMode,
                    //国际化
                    localizationsDelegates: const [
                      GlobalMaterialLocalizations.delegate,
                      GlobalCupertinoLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                    ],
                    supportedLocales: const [
                      Locale('zh', 'CH'),
                      Locale('en', 'US'),
                    ],
                    locale: const Locale('zh'),
                    home: const MainScreen(),
                  ),
                );
              },
            );
          } else {
            // 请求未结束，显示loading
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  @override
  void dispose() {
    Global.close();
    super.dispose();
  }
}
