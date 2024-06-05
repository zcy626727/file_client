import 'package:dio/dio.dart';
import 'package:file_client/model/space/group.dart';

import '../team_http_config.dart';

class GroupApi {
  static Future<Group> createGroup({
    required String name,
    required int spaceId,
  }) async {
    var r = await TeamHttpConfig.dio.post(
      "/group/createGroup",
      data: FormData.fromMap({
        "name": name,
        "spaceId": spaceId,
      }),
      options: TeamHttpConfig.options.copyWith(
        extra: {
          "noCache": true,
          "withToken": true,
        },
      ),
    );
    return Group.fromJson(r.data['group']);
  }

  static Future<void> deleteGroup({
    required int spaceId,
    required int groupId,
  }) async {
    await TeamHttpConfig.dio.delete(
      "/group/deleteGroup",
      queryParameters: {
        "spaceId": spaceId,
        "groupId": groupId,
      },
      options: TeamHttpConfig.options.copyWith(
        extra: {
          "noCache": true,
          "withToken": true,
        },
      ),
    );
  }

  static Future<Group> renameGroup({
    required String newName,
    required int spaceId,
  }) async {
    var r = await TeamHttpConfig.dio.put(
      "/group/renameGroup",
      data: FormData.fromMap({
        "newName": newName,
        "spaceId": spaceId,
      }),
      options: TeamHttpConfig.options.copyWith(
        extra: {
          "noCache": true,
          "withToken": true,
        },
      ),
    );
    return Group.fromJson(r.data['group']);
  }

  //获取空间中该用户的组列表
  static Future<List<Group>> getSpaceGroupListByUser({
    required int spaceId,
    required int pageIndex,
    required int pageSize,
  }) async {
    var r = await TeamHttpConfig.dio.get(
      "/group/getSpaceGroupListByUser",
      queryParameters: {
        "spaceId": spaceId,
        "pageIndex": pageIndex,
        "pageSize": pageSize,
      },
      options: TeamHttpConfig.options.copyWith(
        extra: {
          "noCache": true,
          "withToken": true,
        },
      ),
    );

    return _parseGroupList(r);
  }

  //获取空间中全部组列表
  static Future<List<Group>> getSpaceGroupList({
    required int spaceId,
    required int pageIndex,
    required int pageSize,
  }) async {
    var r = await TeamHttpConfig.dio.get(
      "/group/getSpaceGroupList",
      queryParameters: {
        "spaceId": spaceId,
        "pageIndex": pageIndex,
        "pageSize": pageSize,
      },
      options: TeamHttpConfig.options.copyWith(
        extra: {
          "noCache": true,
          "withToken": true,
        },
      ),
    );

    return _parseGroupList(r);
  }

  static List<Group> _parseGroupList(Response<dynamic> r) {
    List<Group> list = [];
    for (var map in r.data["groupList"]) {
      list.add(Group.fromJson(map));
    }
    return list;
  }
}
