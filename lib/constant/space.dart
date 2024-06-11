class SpaceNav {
  static const int setting = 1;
  static const int member = 2;
  static const int group = 3;
  static const int message = 4;
  static const int workspace = 5;
}

class SpaceUserPermission {
  static const int common = 1;
  static const int admin = 2;

  static String getRole(int? permission) {
    switch (permission) {
      case SpaceUserPermission.admin:
        return "管理员";
      case SpaceUserPermission.common:
        return "成员";
      default:
        return "未知";
    }
  }
}