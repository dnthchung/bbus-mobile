import 'package:bbus_mobile/core/cache/secure_local_storage.dart';
import 'package:bbus_mobile/core/errors/failures.dart';
import 'package:bbus_mobile/features/authentication/data/data_sources/auth_remote_datasource.dart';
import 'package:bbus_mobile/features/authentication/data/models/login_model.dart';
import 'package:bbus_mobile/features/authentication/domain/entities/user.dart';
import 'package:bbus_mobile/features/authentication/domain/repository/auth_repository.dart';
import 'package:dartz/dartz.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource _authRemoteDatasource;
  final SecureLocalStorage _secureLocalStorage;
  AuthRepositoryImpl(this._authRemoteDatasource, this._secureLocalStorage);

  @override
  Future<Either<Failure, UserEntity>> login(
      {required String username, required String password}) async {
    try {
      final model = LoginModel(username: username, password: password);
      final res = await _authRemoteDatasource.login(model);
      if (res.password != password) {
        return Left(Failure('Credential failure!'));
      }
      await _secureLocalStorage.save(key: 'user_id', value: res.userId);
      return Right(res);
    } catch (e) {
      return Left(Failure('Server failed'));
    }
  }
}
