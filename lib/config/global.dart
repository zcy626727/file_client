import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_client/api/client/share_http_config.dart';
import 'package:file_client/api/client/team_http_config.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../api/client/file_http_config.dart';
import '../api/client/user_http_config.dart';
import '../api/net_cache_interceptor.dart';
import '../api/net_common_interceptor.dart';
import '../common/upload/task/download_task.dart';
import '../common/upload/task/multipart_upload_task.dart';
import '../model/user/user.dart';
import '../service/user/user_service.dart';
import 'database_config.dart';
import 'net_config.dart';

//全局变量（在应用启动前初始化）
class Global {
  static int urlCount = 3;

  //网络缓存配置
  static NetConfig netCacheConfig = NetConfig();

  //网络缓存拦截器
  static NetCacheInterceptor netCacheInterceptor = NetCacheInterceptor();

  //公共拦截器
  static NetCommonInterceptor netCommonInterceptor = NetCommonInterceptor();

  //用户信息对象
  static User user = User();

  //user sqlite查询提供者
  static UserProvider userProvider = UserProvider();
  static UploadTaskProvider uploadTaskProvider = UploadTaskProvider();
  static DownloadTaskProvider downloadTaskProvider = DownloadTaskProvider();

  // 是否为release版
  static bool get isRelease => const bool.fromEnvironment("dart.vm.product");

  //数据库配置
  static DatabaseConfig databaseConfig = DatabaseConfig();

  static Database? database;

  //初始化全局信息（应用启动前调用）
  static Future init() async {
    log("执行初始化");
    // sqlite windows and linux support
    if (!kIsWeb && (Platform.isLinux || Platform.isWindows)) {
      sqfliteFfiInit();
      //instead sqflite databaseFactory
      databaseFactory = databaseFactoryFfi;
    }

    initApi();

    //搜索sqlite
    log("初始化完毕");
  }

  static initApi() async {
    //初始化api
    UserHttpConfig.init();
    FileHttpConfig.init();
    ShareHttpConfig.init();
    TeamHttpConfig.init();
  }

  //初始化相关数据数据（应用启动后调用）
  static Future<String?> openDBAndInitData() async {
    User? recentUser;
    if (kIsWeb) {
      //todo 浏览器读取用户信息
    } else {
      String path = join(
        await getDatabasesPath(),
        Global.databaseConfig.databaseName,
      );
      log("数据库位置为：$path");
      //打开数据库
      database = await openDatabase(
        path,
        version: 1,
        onCreate: (Database db, int version) async {
          //创建数据库
          log("创建表");
          await db.execute(User.createSql);
          await db.execute(UploadTaskProvider.createSql);
          await db.execute(DownloadTask.createSql);
        },
      );

      if (database == null) {
        return "读取本机数据发生错误";
      }

      //赋值给各个 xxxProvider
      userProvider.db = database!;
      uploadTaskProvider.db = database!;
      downloadTaskProvider.db = database!;

      //获取初始化数据
      recentUser = await userProvider.getRecentUser();
    }

    //获取到了就设置为全局
    if (recentUser != null) {
      user = recentUser;
    }

    //如果存在用户token信息
    if (user.token != null && user.phoneNumber != null) {
      //根据token尝试登录
      try {
        user = await UserService.signInByToken(user.phoneNumber!).timeout(const Duration(seconds: 1));
      } on DioException catch (e) {
        //http错误
        if (e.response != null) {
          user.clearUserInfo();
          switch (e.response!.statusCode) {
            case HttpStatus.unauthorized: //校验信息失效
              await userProvider.update(user);
          }
        }
        return e.message;
      } catch (e) {
        return "认证失败";
      }
    } else {
      user = User();
    }

    return null;
  }

  static void close() async {
    if (!kIsWeb) {
      userProvider.db.close();
      uploadTaskProvider.db.close();
      downloadTaskProvider.db.close();
    }
  }

  static initDB() async {
    log("数据库初始化");
  }

  static copyEnv(User user, Database db) async {
    //user信息
    Global.user = user;
    initApi();
    if (kIsWeb) {
      //todo 浏览器读取用户信息
    } else {
      userProvider.db = db;
      uploadTaskProvider.db = db;
      downloadTaskProvider.db = db;
    }
  }
}
