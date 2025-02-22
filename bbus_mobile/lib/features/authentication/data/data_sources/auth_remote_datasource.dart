import 'package:bbus_mobile/core/constants/api_constants.dart';
import 'package:bbus_mobile/core/constants/error_messages.dart';
import 'package:bbus_mobile/core/errors/exceptions.dart';
import 'package:bbus_mobile/core/network/dio_client.dart';
import 'package:bbus_mobile/core/utils/logger.dart';
import 'package:bbus_mobile/features/authentication/data/models/login_model.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRemoteDatasource {
  Future<Map<String, dynamic>> login(LoginModel loginModel);
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
    } catch (e) {
      logger.e(e);
      if (e.toString() == noElement) {
        throw AuthException();
      }
      throw ServerException();
    }
  }
}
