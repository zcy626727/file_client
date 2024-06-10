import 'package:file_client/model/space/space_user.dart';

import '../../api/client/team/space_user.dart';

class SpaceUserService {
  static Future<void> deleteUser({
    required int spaceUserId,
  }) async {
    await SpaceUserApi.deleteUser(spaceUserId: spaceUserId);
  }

  static Future<SpaceUser?> getSpaceUser({
    required int spaceId,
  }) async {
    return await SpaceUserApi.getSpaceUser(spaceId: spaceId);
  }
}
