import 'package:dio/dio.dart';

import '../../config/global.dart';

class NetCommonInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.extra["withToken"] == true) {
      //需要携带token
      //将token加到请求头
      // options.headers[HttpHeaders.authorizationHeader] = Global.user.token;
      options.headers["Authorization"] = "Bearer ${Global.user.token}";
    }

    handler.next(options);
  }
}
