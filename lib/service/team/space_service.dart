import 'package:file_client/model/space/space.dart';

import '../../api/client/team/space_api.dart';

class SpaceService {
  static Future<Space> createCreate({
     String? name,
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
  }) async {
    await SpaceApi.updateSpace(spaceId: spaceId, newName: newName, newAvatarUrl: newAvatarUrl);
  }
}
