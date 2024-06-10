import 'package:file_client/config/net_config.dart';
import 'package:file_client/model/space/space.dart';

import '../../api/client/team/space_api.dart';

class SpaceService {
  static Future<Space> createCreate({
    required String name,
    String? avatarUrl,
    String? description,
  }) async {
    var space = await SpaceApi.createSpace(name: name, avatarUrl: avatarUrl, description: description);
    return space;
  }

  static Future<void> deleteSpace({
    required int spaceId,
  }) async {
    await SpaceApi.deleteSpace(spaceId: spaceId);
  }

  static Future<void> updateSpace({
    required int spaceId,
    String? newName,
    String? newAvatarUrl,
    String? newDescription,
  }) async {
    await SpaceApi.updateSpace(spaceId: spaceId, newName: newName, newAvatarUrl: newAvatarUrl, newDescription: newDescription);
  }

  static Future<List<Space>> getUserSpaceList({
    int pageIndex = 0,
    int pageSize = NetConfig.commonPageSize,
  }) async {
    return await SpaceApi.getUserSpaceList(pageIndex: pageIndex, pageSize: pageSize);
  }

  static Future<List<Space>> searchSpaceList({
    required String keyword,
    int pageIndex = 0,
    int pageSize = NetConfig.commonPageSize,
  }) async {
    return await SpaceApi.searchSpaceList(keyword: keyword, pageIndex: pageIndex, pageSize: pageSize);
  }
}
