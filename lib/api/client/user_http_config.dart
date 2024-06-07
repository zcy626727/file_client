import 'package:dio/dio.dart';

import '../../../config/global.dart';
import '../../config/net_config.dart';

class UserHttpConfig {
  // 在网络请求过程中可能会需要使用当前的context信息，比如在请求失败时
  // 打开一个新路由，而打开新路由需要context信息。

  //当前接口的选项
  static Options options = Options();

  static Dio dio = Dio(BaseOptions(
    baseUrl: NetConfig.userApiUrl,
  ));

  static void init() {
    // 添加拦截器
    dio.interceptors.add(Global.netCacheInterceptor);
    dio.interceptors.add(Global.netCommonInterceptor);
  }
}
