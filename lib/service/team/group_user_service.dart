import '../../api/client/team/group_user_api.dart';
import '../../model/space/group_user.dart';

class GroupUserService {
  static Future<GroupUser> addGroup({
    required int groupId,
    required int targetUserId,
  }) async {
    var group = await GroupUserApi.addGroup(groupId: groupId, targetUserId: targetUserId);
    return group;
  }

  static Future<void> removeGroup({
    required int groupId,
    required int targetUserId,
  }) async {
    await GroupUserApi.removeGroup(groupId: groupId, targetUserId: targetUserId);
  }
}
