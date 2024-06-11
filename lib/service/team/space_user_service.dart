import 'package:file_client/config/net_config.dart';
import 'package:file_client/model/space/space_user.dart';

import '../../api/client/team/space_user.dart';

class SpaceUserService {
  static Future<void> removeUser({
    required int spaceUserId,
  }) async {
    await SpaceUserApi.removeUser(spaceUserId: spaceUserId);
  }

  static Future<SpaceUser?> getSpaceUser({
    required int spaceId,
  }) async {
    return await SpaceUserApi.getSpaceUser(spaceId: spaceId);
  }

  static Future<List<SpaceUser>> getSpaceUserList({
    required int spaceId,
    int pageIndex = 0,
    int pageSize = NetConfig.commonPageSize,
  }) async {
    return await SpaceUserApi.getSpaceUserList(spaceId: spaceId, pageIndex: pageIndex, pageSize: pageSize);
  }
}
