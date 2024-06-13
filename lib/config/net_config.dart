class NetConfig {
  NetConfig({this.enable = false, this.maxAge = 3600, this.maxCount = 100});

  //是否开启缓存
  bool enable;

  //最大过期时间
  int maxAge;

  //最大连接数
  int maxCount;

  static const int commonPageSize = 20;

  static String baseUrl = "http://192.168.200.148";

  //用户服务
  static String userApiUrl = '$baseUrl:26201';

  //用户服务
  static String fileApiUrl = '$baseUrl:26211';
  static String accessShareUrl = '$baseUrl:26211/share/accessShare';

  //分享服务
  static String shareApiUrl = '$baseUrl:26221';

  //团队服务
  static String teamApiUrl = '$baseUrl:26231';
}
