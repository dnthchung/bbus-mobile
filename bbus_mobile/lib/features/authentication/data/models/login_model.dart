import 'package:bbus_mobile/features/authentication/domain/entities/user.dart';

class LoginModel extends UserEntity {
  const LoginModel({
    required String username,
    required String password,
  }) : super(username: username, password: password);
  Map<String, dynamic> toMap() {
    return <String, dynamic>{'username': username, 'password': password};
  }
}
