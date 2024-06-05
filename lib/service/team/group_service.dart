import 'package:file_client/config/net_config.dart';
import 'package:file_client/model/space/group.dart';

import '../../api/client/team/group_api.dart';

class GroupService {
  static Future<Group> createFile({
    required String name,
    required int spaceId,
  }) async {
    var group = await GroupApi.createGroup(name: name, spaceId: spaceId);
    return group;
  }

  static Future<void> deleteGroup({
    required int spaceId,
    required int groupId,
  }) async {
    await GroupApi.deleteGroup(spaceId: spaceId, groupId: groupId);
  }

  static Future<void> renameGroup({
    required String newName,
    required int spaceId,
  }) async {
    await GroupApi.renameGroup(newName: newName, spaceId: spaceId);
  }

  static Future<List<Group>> getSpaceGroupListByUser({
    required int spaceId,
    int pageIndex = 0,
    int pageSize = NetConfig.commonPageSize,
  }) async {
    return await GroupApi.getSpaceGroupListByUser(spaceId: spaceId, pageIndex: pageIndex, pageSize: pageSize);
  }

  static Future<List<Group>> getSpaceGroupList({
    required int spaceId,
    int pageIndex = 0,
    int pageSize = NetConfig.commonPageSize,
  }) async {
    return await GroupApi.getSpaceGroupList(spaceId: spaceId, pageIndex: pageIndex, pageSize: pageSize);
  }
}
