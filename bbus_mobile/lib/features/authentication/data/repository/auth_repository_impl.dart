import 'dart:convert';

import 'package:bbus_mobile/core/cache/secure_local_storage.dart';
import 'package:bbus_mobile/core/errors/exceptions.dart';
import 'package:bbus_mobile/core/errors/failures.dart';
import 'package:bbus_mobile/core/usecases/usecase.dart';
import 'package:bbus_mobile/core/utils/jwt_converter.dart';
import 'package:bbus_mobile/core/utils/logger.dart';
import 'package:bbus_mobile/features/authentication/data/data_sources/auth_local_datasource.dart';
import 'package:bbus_mobile/features/authentication/data/data_sources/auth_remote_datasource.dart';
import 'package:bbus_mobile/features/authentication/data/models/login_model.dart';
import 'package:bbus_mobile/features/authentication/data/models/user_model.dart';
import 'package:bbus_mobile/features/authentication/domain/entities/user.dart';
import 'package:bbus_mobile/features/authentication/domain/repository/auth_repository.dart';
import 'package:dartz/dartz.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource _authRemoteDatasource;
  final SecureLocalStorage _secureLocalStorage;
  final AuthLocalDatasource _authLocalDatasource;
  AuthRepositoryImpl(this._authRemoteDatasource, this._secureLocalStorage,
      this._authLocalDatasource);
  @override
  Future<Either<Failure, UserEntity>> login(
      {required String phone, required String password}) async {
    try {
      final model = LoginModel(phone: phone, password: password);
      final result = await _authRemoteDatasource.login(model);
      if (result['status'] == 401) {
        return Left(CredentialFailure());
      }
      final tokenPayload = parseJwt(result['access_token']);
      await _secureLocalStorage.save(
        key: 'token',
        value: result['access_token'],
      );
      await _secureLocalStorage.save(
        key: 'refresh_token',
        value: result['refresh_token'],
      );
      await _secureLocalStorage.save(
        key: 'userId',
        value: tokenPayload['userId'].toString(),
      );
      final user = await _authRemoteDatasource
          .getUserDetail(tokenPayload['userId'].toString());
      await _secureLocalStorage.save(
        key: 'user',
        value: jsonEncode(user.toMap()),
      );
      return Right(user);
    } on ServerException {
      return Left(ServerFailure());
    } on AuthException {
      return Left(CredentialFailure());
    }
  }

  @override
  Future<Either<Failure, UserEntity>> checkLoggedInStatus() async {
    try {
      final result = await _authLocalDatasource.checkLoggedInStatus();
      final user = UserModel.fromJson(result);
      return Right(user);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      final result = _authRemoteDatasource.logout();
      await _secureLocalStorage.delete(
        key: 'token',
      );
      await _secureLocalStorage.delete(
        key: 'refresh_token',
      );
      await _secureLocalStorage.delete(
        key: 'user',
      );
      await _secureLocalStorage.delete(
        key: 'userId',
      );
      return Right(result);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
