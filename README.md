# 网盘

## 功能

- 用户服务
- 文件服务（核心服务）
  - 个人文件
    - 上传文件
    - 新建文件夹
    - 重命名
    - 移动
    - 删除
  - 回收站
    - 彻底删除：支持递归删除文件夹
    - 恢复
  - 链接分享
- 分享服务
  - 主题分享
  - 合集分享
- 团队服务
  - 团队空间
  - 用户组
  - 空间文件

## 环境

### 生成json代码

```shell
flutter pub run build_runner build --delete-conflicting-outputs
```