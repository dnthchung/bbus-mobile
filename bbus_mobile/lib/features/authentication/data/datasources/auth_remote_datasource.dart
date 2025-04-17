import 'dart:io';

import 'package:bbus_mobile/core/constants/api_constants.dart';
import 'package:bbus_mobile/core/errors/exceptions.dart';
import 'package:bbus_mobile/core/network/api_exception.dart';
import 'package:bbus_mobile/core/network/dio_client.dart';
import 'package:bbus_mobile/core/utils/device_utils.dart';
import 'package:bbus_mobile/core/utils/logger.dart';
import 'package:bbus_mobile/features/authentication/data/models/login_model.dart';
import 'package:bbus_mobile/features/authentication/data/models/reset_password_model.dart';
import 'package:bbus_mobile/features/authentication/data/models/user_model.dart';
import 'package:bbus_mobile/features/change_password/data/models/change_password_model.dart';

abstract class AuthRemoteDatasource {
  Future<Map<String, dynamic>> login(LoginModel loginModel);
  Future<UserModel> getUserDetail(String userId);
  // Future<String> getEntityId(String userId);
  Future<void> logout();
  Future<dynamic> getOtp(String phoneNumber);
  Future<dynamic> sendOtp({required String phone, required String otp});
  Future<dynamic> resetPassword(ResetPasswordModel model);
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

  @override
  Future getOtp(String phoneNumber) async {
    try {
      final res = await _dioClient
          .post('${ApiConstants.forgotPassword}?email=$phoneNumber');
      return res;
    } catch (e) {
      logger.e(e);
      throw ServerException(e.toString());
    }
  }

  @override
  Future resetPassword(ResetPasswordModel model) async {
    try {
      final res = await _dioClient.post(ApiConstants.resetPassword,
          data: model.toJson());
      return res;
    } catch (e) {
      logger.e(e);
      throw ServerException(e.toString());
    }
  }

  @override
  Future sendOtp({required String phone, required String otp}) async {
    try {
      final res = await _dioClient
          .post('${ApiConstants.otpVerification}?email=$phone&otp=$otp');
      return res;
    } catch (e) {
      logger.e(e);
      throw ServerException(e.toString());
    }
  }
}
