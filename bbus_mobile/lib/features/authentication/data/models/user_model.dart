import 'package:bbus_mobile/features/authentication/domain/entities/user.dart';

class UserModel extends UserEntity {
  UserModel({
    required int id,
    required String username,
    required String fullName,
  }) : super(id: id, username: username, fullName: fullName);
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        id: json['id'], username: json['username'], fullName: json['fullName']);
  }
}
