import 'dart:io';

import 'package:bbus_mobile/core/constants/api_constants.dart';
import 'package:bbus_mobile/core/errors/exceptions.dart';
import 'package:bbus_mobile/core/network/api_exception.dart';
import 'package:bbus_mobile/core/network/dio_client.dart';
import 'package:bbus_mobile/core/utils/logger.dart';
import 'package:bbus_mobile/features/authentication/data/models/login_model.dart';
import 'package:bbus_mobile/features/authentication/data/models/user_model.dart';

abstract class AuthRemoteDatasource {
  Future<Map<String, dynamic>> login(LoginModel loginModel);
  Future<UserModel> getUserDetail(String userId);
  Future<void> logout();
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final DioClient _dioClient;
  AuthRemoteDatasourceImpl(this._dioClient);
  @override
  Future<Map<String, dynamic>> login(LoginModel loginModel) async {
    try {
      var res = await _dioClient.post(ApiConstants.loginApiUrl,
          data: loginModel.toMap());
      return res;
    } on SocketException {
      throw FetchDataException('No Internet Connection!');
    } catch (e) {
      logger.e(e);
      if (e.toString() == 'Bad state: No element') {
        throw AuthException();
      }
      throw ServerException();
    }
  }

  @override
  Future<UserModel> getUserDetail(String userId) async {
    try {
      var res = await _dioClient.get('${ApiConstants.userApiUrl}/$userId');
      final user = UserModel.fromJson(res['data']);
      return user;
    } on SocketException {
      throw FetchDataException('No Internet Connection!');
    } catch (e) {
      logger.e(e);
      throw ServerException();
    }
  }

  @override
  Future<void> logout() async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      return;
    } catch (e) {
      logger.e(e);
      throw ServerException();
    }
  }
}
