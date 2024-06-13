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

class SpaceFilePermission {
  // 可预览
  static const int read = 2;
  static const int download = 3;
  static const int write = 4;

  // 可编辑/删除/修改信息
  static const int admin = 5;

  static const List<(int, String)> filePermissionList = [(read, "可读"), (download, "可下载"), (write, "可写"), (admin, "管理员")];
  static const List<(int, String)> folderPermissionList = [(read, "可读"), (write, "可写"), (admin, "管理员")];

  static String getFilePermissionStr(int permission) {
    switch (permission) {
      case read:
        return "可读";
      case download:
        return "可下载";
      case write:
        return "可写";
      case admin:
        return "管理员";
      default:
        return "——";
    }
  }

  static String getFolderPermissionStr(int permission) {
    switch (permission) {
      case read:
        return "可读";
      case write:
        return "可写";
      case admin:
        return "管理员";
      default:
        return "——";
    }
  }
}
