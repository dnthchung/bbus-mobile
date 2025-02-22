import 'package:bbus_mobile/features/authentication/domain/entities/user.dart';

class LoginModel extends UserEntity {
  const LoginModel({
    required String phone,
    required String password,
  }) : super(phone: phone, password: password);
  Map<String, dynamic> toMap() {
    return <String, dynamic>{'phone': phone, 'password': password};
  }
}
