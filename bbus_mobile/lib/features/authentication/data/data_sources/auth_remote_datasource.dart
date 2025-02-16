import 'dart:convert';

import 'package:bbus_mobile/config/injector/injector_conf.dart';
import 'package:bbus_mobile/core/constants/api_constants.dart';
import 'package:bbus_mobile/core/network/dio_client.dart';
import 'package:bbus_mobile/features/authentication/data/models/login_model.dart';
import 'package:bbus_mobile/features/authentication/data/models/user_model.dart';

abstract class AuthRemoteDatasource {
  Future<UserModel> login(LoginModel loginModel);
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  @override
  Future<UserModel> login(LoginModel loginModel) async {
    try {
      var res = await sl<DioClient>()
          .post(ApiConstants.loginApiUrl, data: loginModel.toMap());
      return UserModel.fromJson(jsonDecode(res) as Map<String, dynamic>);
    } catch (e) {}
  }
}
