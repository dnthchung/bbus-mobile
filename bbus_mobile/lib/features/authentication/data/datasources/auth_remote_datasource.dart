import 'dart:io';
import 'dart:typed_data';

import 'package:bbus_mobile/common/notifications/notification_service.dart';
import 'package:bbus_mobile/config/injector/injector.dart';
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
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

abstract class AuthRemoteDatasource {
  Future<Map<String, dynamic>> login(LoginModel loginModel);
  Future<UserModel> getUserDetail(String userId);
  Future<dynamic> updateUserProfile(UserModel userModel);
  // Future<String> getEntityId(String userId);
  Future<void> logout();
  Future<void> updatDeviceToken(String fcmToken);
  Future<dynamic> getOtp(String phoneNumber);
  Future<dynamic> sendOtp({required String phone, required String otp});
  Future<dynamic> resetPassword(ResetPasswordModel model);
  Future<dynamic> updateAvatar(Uint8List imageBytes);
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final DioClient _dioClient;
  AuthRemoteDatasourceImpl(this._dioClient);
  @override
  Future<Map<String, dynamic>> login(LoginModel loginModel) async {
    try {
      final fcmToken = await sl<NotificationService>().getFcmToken();
      LoginModel loginWithDeviceToken =
          loginModel.loginCopyWith(deviceToken: fcmToken);
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

  @override
  Future<void> updatDeviceToken(String fcmToken) async {
    try {
      final res =
          await _dioClient.post('${ApiConstants.updatDeviceToken}', data: {
        'deviceId': fcmToken,
      });
      return res;
    } catch (e) {
      logger.e(e);
      throw ServerException(e.toString());
    }
  }

  @override
  Future<dynamic> updateUserProfile(UserModel userModel) async {
    try {
      var res = await _dioClient.put(ApiConstants.updateProfile,
          data: userModel.toMap());
      logger.i(res['data']);
      return res;
    } on SocketException {
      throw FetchDataException('No Internet Connection!');
    } catch (e) {
      logger.e(e);
      throw ServerException(e.toString());
    }
  }

  @override
  Future updateAvatar(Uint8List imageBytes) {
    try {
      final fileName = "avatar_${DateTime.now().millisecondsSinceEpoch}.jpg";
      final formData = FormData.fromMap({
        'avatar': MultipartFile.fromBytes(imageBytes,
            filename: fileName, contentType: DioMediaType('image', 'jpg')),
      });
      final res = _dioClient.patch(
        ApiConstants.updateAvatar,
        data: formData,
        options: Options(headers: {
          'Content-Type': 'multipart/form-data',
        }),
      );
      return res;
    } catch (e) {
      logger.e(e);
      throw ServerException(e.toString());
    }
  }
}
