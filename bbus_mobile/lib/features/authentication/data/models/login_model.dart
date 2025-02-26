import 'package:bbus_mobile/features/authentication/domain/entities/user.dart';

class LoginModel extends UserEntity {
  final String platform;
  final String deviceToken;
  final String versionApp;
  const LoginModel({
    required String phone,
    required String password,
    this.platform = "MOBILE",
    this.deviceToken = "x-token",
    this.versionApp = 'v1.2.9',
  }) : super(phone: phone, password: password);
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'phone': phone,
      'password': password,
      'platform': platform,
      'deviceToken': deviceToken,
      'versionApp': versionApp,
    };
  }
}
