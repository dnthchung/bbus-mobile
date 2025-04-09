import 'dart:io';

import 'package:bbus_mobile/core/constants/api_constants.dart';
import 'package:bbus_mobile/core/errors/exceptions.dart';
import 'package:bbus_mobile/core/network/api_exception.dart';
import 'package:bbus_mobile/core/network/dio_client.dart';
import 'package:bbus_mobile/core/utils/device_utils.dart';
import 'package:bbus_mobile/core/utils/logger.dart';
import 'package:bbus_mobile/features/authentication/data/models/login_model.dart';
import 'package:bbus_mobile/features/authentication/data/models/user_model.dart';

abstract class AuthRemoteDatasource {
  Future<Map<String, dynamic>> login(LoginModel loginModel);
  Future<UserModel> getUserDetail(String userId);
  // Future<String> getEntityId(String userId);
  Future<void> logout();
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final DioClient _dioClient;
  AuthRemoteDatasourceImpl(this._dioClient);
  @override
  Future<Map<String, dynamic>> login(LoginModel loginModel) async {
    try {
      final DeviceDetails details = await getDeviceDetails();
      LoginModel loginWithDeviceToken =
          loginModel.copyWith(deviceToken: details.deviceId);
      var res = await _dioClient.post(ApiConstants.loginApiUrl,
          data: loginWithDeviceToken.toMap());
      return res;
    } on SocketException {
      throw FetchDataException('No Internet Connection!');
    } catch (e) {
      logger.e(e);
      if (e.toString() == 'Bad state: No element') {
        throw AuthException();
      }
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> getUserDetail(String userId) async {
    try {
      var res = await _dioClient.get('${ApiConstants.userApiUrl}/$userId');
      logger.i(res['data']);
      final user = UserModel.fromJson(res['data']);
      return user;
    } on SocketException {
      throw FetchDataException('No Internet Connection!');
    } catch (e) {
      logger.e(e);
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> logout() async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      return;
    } catch (e) {
      logger.e(e);
      throw ServerException(e.toString());
    }
  }

  // @override
  // Future<String> getEntityId(String userId) async {
  //   try {
  //     var res =
  //         await _dioClient.get('${ApiConstants.userApiUrl}/entity/$userId');
  //     final entityId = res['data']['id'];
  //     return entityId;
  //   } on SocketException {
  //     throw FetchDataException('No Internet Connection!');
  //   } catch (e) {
  //     logger.e(e);
  //     throw ServerException(e.toString());
  //   }
  // }
}
