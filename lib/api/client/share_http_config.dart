
import 'package:dio/dio.dart';

import '../../config/global.dart';
import '../../config/net_config.dart';

class ShareHttpConfig {
  static Options options = Options();

  static Dio dio = Dio(BaseOptions(
    baseUrl: NetConfig.shareApiUrl,
  ));

  static void init() {
    // 添加拦截器
    dio.interceptors.add(Global.netCacheInterceptor);
    dio.interceptors.add(Global.netCommonInterceptor);
  }
}
