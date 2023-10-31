
import 'package:dio/dio.dart';

import '../../../model/user/user.dart';
import '../user_http_config.dart';

class UserApi {
  static Future<User> signIn(String phoneNumber, String password) async {
    var r = await UserHttpConfig.dio.post(
      "/user/signIn",
      data: FormData.fromMap({
        "phoneNumber": phoneNumber,
        "password": password,
      }),
      options: UserHttpConfig.options.copyWith(extra: {"noCache": true}),
    );

    //获取数据
    User user = User.fromJson(r.data["user"]);
    user.token = r.data["token"];
    return user;
  }

  static Future<User> signInByToken(String phoneNumber) async {
    var r = await UserHttpConfig.dio.post(
      "/user/signInByToken",
      data: FormData.fromMap({
        "phoneNumber": phoneNumber,
      }),
      options: UserHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );

    //获取数据
    User user = User.fromJson(r.data["user"]);
    user.token = r.data["token"] ?? "";
    return user;
  }

  static Future<User> signUp(String phoneNumber, String password, String name) async {
    var r = await UserHttpConfig.dio.post(
      "/user/signUp",
      data: FormData.fromMap({
        "phoneNumber": phoneNumber,
        "password": password,
        "name": name,
      }),
      options: UserHttpConfig.options.copyWith(extra: {"noCache": true}),
    );

    //获取数据
    User user = User.fromJson(r.data["user"]);
    user.token = r.data["token"] ?? "";
    return user;
  }

  static Future<User> getUserInfo({required int targetUserId}) async {
    var r = await UserHttpConfig.dio.get(
      "/user/getUserInfo",
      queryParameters: {
        "targetUserId": targetUserId,
      },
      options: UserHttpConfig.options.copyWith(extra: {"noCache": true, "withToken": false}),
    );

    return User.fromJson(r.data["user"]);
  }

  static Future<void> updateUser({String? avatarUrl, String? name}) async {
    var r = await UserHttpConfig.dio.post(
      "/user/updateUser",
      data: FormData.fromMap({
        "avatarUrl": avatarUrl,
        "name": name,
      }),
      options: UserHttpConfig.options.copyWith(extra: {"noCache": true, "withToken": true}),
    );
  }

  static Future<void> updatePassword({required String phoneNumber, required String oldPassword, required String newPassword}) async {
    var r = await UserHttpConfig.dio.post(
      "/user/updatePassword",
      data: FormData.fromMap({
        "phoneNumber": phoneNumber,
        "oldPassword": oldPassword,
        "newPassword": newPassword,
      }),
      options: UserHttpConfig.options.copyWith(extra: {"noCache": true, "withToken": true}),
    );
  }
}
