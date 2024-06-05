import '../../api/client/team/space_user.dart';

class SpaceUserService {
  static Future<void> deleteUser({
    required int spaceUserId,
  }) async {
    await SpaceUserApi.deleteUser(spaceUserId: spaceUserId);
  }
}
