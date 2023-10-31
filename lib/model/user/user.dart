import 'package:json_annotation/json_annotation.dart';
import 'package:sqflite/sqflite.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  User({
    this.id,
    this.phoneNumber,
    this.lastLoginTime,
    this.token,
    this.avatarUrl,
    this.name,
    this.themeMode = 0,
  });

  String? phoneNumber;
  int? id;
  String? name;

  String? token;
  String? lastLoginTime;
  String? avatarUrl;

  //0：跟随系统，1：亮，2：暗
  int themeMode = 0;

  static String createSql = '''
    create table user ( 
      id integer primary key autoincrement, 
      name text not null,
      token text,
      lastLoginTime text not null,
      phoneNumber text not null,
      avatarUrl text,
      themeMode integer not null
    )
  ''';

  bool alreadyLogin() {
    if (id == null || token == null) {
      return false;
    } else {
      return true;
    }
  }

  String formatId() {
    if (id != null) {
      return "$id".padLeft(10, "0");
    } else {
      return "";
    }
  }

  // Map<String, dynamic> toDBMap() {
  //   return {
  //     "_id": id,
  //     "name": name,
  //     "phone_number": phoneNumber,
  //     "token": token,
  //     "avatar_url": avatarUrl,
  //     "last_login": lastLogin,
  //     "theme_mode": themeMode,
  //   };
  // }
  //
  // User.fromDBMap(Map<String, Object?> map) {
  //   id = map["_id"] as int?;
  //   phoneNumber = map["phone_number"] as String?;
  //   lastLogin = map["last_login"] as String?;
  //   name = map["name"] as String?;
  //   token = map["token"] as String?;
  //   avatarUrl = map["avatar_url"] as String?;
  //   themeMode = (map["theme_mode"] ?? 0) as int;
  // }

  void clearUserInfo() {
    name = null;
    phoneNumber = null;
    token = null;
    id = null;
    avatarUrl = null;
    themeMode = 0;
  }

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}

class UserProvider {
  late Database db;

  Future<User> insertOrUpdate(User user) async {
    user.id = await db.insert(
      "user",
      user.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return user;
  }

  Future<User?> getUserByPhoneNumber(String phoneNumber) async {
    List<Map<String, Object?>> maps = await db.query(
      "user",
      columns: [
        "id",
        "name",
        "phoneNumber",
        "token",
        "avatarUrl",
        "lastLoginTime",
        "themeMode",
      ],
      where: 'phoneNumber = ?',
      whereArgs: [phoneNumber],
    );
    if (maps.isNotEmpty) {
      return User.fromJson(maps.first);
    }
    return null;
  }

  Future<User?> getRecentUser() async {
    List<Map<String, Object?>> maps = await db.query(
      "user",
      columns: [
        "id",
        "name",
        "phoneNumber",
        "token",
        "avatarUrl",
        "lastLoginTime",
        "themeMode",
      ],
      orderBy: "lastLoginTime desc",
      limit: 1,
    );
    if (maps.isNotEmpty) {
      return User.fromJson(maps.first);
    }
    return null;
  }

  Future<int> delete(int id) async {
    return await db.delete("user", where: 'id = ?', whereArgs: [id]);
  }

  Future<int> update(User user) async {
    return await db
        .update("user", user.toJson(), where: 'id = ?', whereArgs: [user.id]);
  }
}
