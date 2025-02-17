import 'package:bbus_mobile/core/cache/secure_local_storage.dart';
import 'package:bbus_mobile/core/errors/failures.dart';
import 'package:bbus_mobile/features/authentication/data/data_sources/auth_remote_datasource.dart';
import 'package:bbus_mobile/features/authentication/data/models/login_model.dart';
import 'package:bbus_mobile/features/authentication/domain/repository/auth_repository.dart';
import 'package:dartz/dartz.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource _authRemoteDatasource;
  final SecureLocalStorage _secureLocalStorage;
  AuthRepositoryImpl(this._authRemoteDatasource, this._secureLocalStorage);

  @override
  Future<Either<Failure, bool>> login(
      {required String username, required String password}) async {
    try {
      final model = LoginModel(username: username, password: password);
      Either res = await _authRemoteDatasource.login(model);
      return res.fold((error) {
        return Left(error);
      }, (data) async {
        await _secureLocalStorage.save(
            key: 'token', value: data['access_token']);
        await _secureLocalStorage.save(
            key: 'refresh_token', value: data['refresh_token']);
        return Right(data);
      });
    } catch (e) {
      return Left(Failure('Server failed'));
    }
  }
}
