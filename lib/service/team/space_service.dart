import 'package:file_client/model/space/space.dart';

import '../../api/client/team/space_api.dart';

class SpaceService {
  static Future<Space> createFile({
    required String name,
    required String avatarUrl,
  }) async {
    var space = await SpaceApi.createSpace(name: name, avatarUrl: avatarUrl);
    return space;
  }

  static Future<void> deleteSpace({
    required int spaceId,
  }) async {
    await SpaceApi.deleteSpace(spaceId: spaceId);
  }

  static Future<void> updateSpace({
    required int spaceId,
    required String newName,
    required String newAvatarUrl,
  }) async {
    await SpaceApi.updateSpace(spaceId: spaceId, newName: newName, newAvatarUrl: newAvatarUrl);
  }
}
