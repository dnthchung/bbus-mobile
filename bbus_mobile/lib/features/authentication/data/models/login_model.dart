import 'package:bbus_mobile/common/entities/user.dart';
import 'package:bbus_mobile/core/utils/device_utils.dart';

class LoginModel extends UserEntity {
  final String platform;
  final String? deviceToken;
  final String versionApp;
  const LoginModel({
    String? phone,
    String? password,
    this.platform = "MOBILE",
    this.deviceToken,
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

  LoginModel loginCopyWith({
    String? phone,
    String? password,
    String? platform,
    String? deviceToken,
    String? versionApp,
  }) {
    return LoginModel(
      phone: phone ?? this.phone,
      password: password ?? this.password,
      platform: platform ?? this.platform,
      deviceToken: deviceToken ?? this.deviceToken,
      versionApp: versionApp ?? this.versionApp,
    );
  }
}
