import 'package:bbus_mobile/features/authentication/domain/entities/user.dart';

class UserModel extends UserEntity {
  UserModel({
    required int userId,
    required String username,
    required String fullName,
  }) : super(userId: userId, username: username, fullName: fullName);
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        userId: json['userId'],
        username: json['username'],
        fullName: json['fullName']);
  }
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'userId': userId,
      'username': username,
      'fullname': fullName
    };
  }
}
