import '../../api/client/team/group_user_api.dart';
import '../../model/space/group_user.dart';

class GroupUserService {
  static Future<GroupUser> addGroup({
    required int spaceId,
    required int targetUserId,
  }) async {
    var group = await GroupUserApi.addGroup(spaceId: spaceId, targetUserId: targetUserId);
    return group;
  }

  static Future<void> deleteGroup({
    required int groupUserId,
  }) async {
    await GroupUserApi.removeGroup(groupUserId: groupUserId);
  }
}
