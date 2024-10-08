// 文件和文件夹


class CommonResource {
  // id
  int? id;

  // 名字
  String? name;

  // 文件/文件夹的状态，普通，删除等
  int? status;

  int? userId;

  // 文件夹id
  int? parentId;

  int? fileType;

  // 创建时间
  DateTime? createTime;

  CommonResource({
    this.id,
    this.name,
    this.status,
    this.parentId,
    this.createTime,
    this.fileType,
    this.userId,
  });
}
