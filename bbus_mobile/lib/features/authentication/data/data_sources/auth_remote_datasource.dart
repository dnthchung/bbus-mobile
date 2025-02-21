import 'package:bbus_mobile/config/injector/injector.dart';
import 'package:bbus_mobile/core/constants/api_constants.dart';
import 'package:bbus_mobile/core/network/dio_client.dart';
import 'package:bbus_mobile/features/authentication/data/models/login_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

abstract class AuthRemoteDatasource {
  Future<Either> login(LoginModel loginModel);
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final DioClient _dioClient;
  AuthRemoteDatasourceImpl(this._dioClient);
  @override
  Future<Either> login(LoginModel loginModel) async {
    try {
      var res = await _dioClient.post(ApiConstants.loginApiUrl,
          data: loginModel.toMap());
      return Right(res);
    } on DioException catch (e) {
      return Left(e.response!.data['message']);
    }
  }
}
