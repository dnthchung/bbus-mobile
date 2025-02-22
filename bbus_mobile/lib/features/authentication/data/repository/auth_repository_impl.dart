import 'package:bbus_mobile/core/cache/secure_local_storage.dart';
import 'package:bbus_mobile/core/errors/exceptions.dart';
import 'package:bbus_mobile/core/errors/failures.dart';
import 'package:bbus_mobile/features/authentication/data/data_sources/auth_local_datasource.dart';
import 'package:bbus_mobile/features/authentication/data/data_sources/auth_remote_datasource.dart';
import 'package:bbus_mobile/features/authentication/data/models/login_model.dart';
import 'package:bbus_mobile/features/authentication/domain/repository/auth_repository.dart';
import 'package:dartz/dartz.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource _authRemoteDatasource;
  final SecureLocalStorage _secureLocalStorage;
  final AuthLocalDatasource _authLocalDatasource;
  AuthRepositoryImpl(this._authRemoteDatasource, this._secureLocalStorage,
      this._authLocalDatasource);
  @override
  Future<Either<Failure, Map<String, dynamic>>> login(
      {required String phone, required String password}) async {
    try {
      final model = LoginModel(phone: phone, password: password);
      final result = await _authRemoteDatasource.login(model);
      if (result['status'] == 401) {
        return Left(CredentialFailure());
      }
      await _secureLocalStorage.save(
        key: 'token',
        value: result['access_token'],
      );
      await _secureLocalStorage.save(
        key: 'refresh_token',
        value: result['refresh_token'],
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> checkLoggedInStatus() async {
    try {
      final result = await _authLocalDatasource.checkLoggedInStatus();
      return Right(result);
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}
