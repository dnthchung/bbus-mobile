import 'package:bbus_mobile/core/cache/secure_local_storage.dart';
import 'package:bbus_mobile/core/errors/exceptions.dart';
import 'package:bbus_mobile/core/errors/failures.dart';
import 'package:bbus_mobile/features/change_password/data/datasources/change_password_remote_datasource.dart';
import 'package:bbus_mobile/features/change_password/data/models/change_password_model.dart';
import 'package:bbus_mobile/features/change_password/domain/repository/change_password_repository.dart';
import 'package:dartz/dartz.dart';

class ChangePasswordRepositoryImpl implements ChangePasswordRepository {
  final ChangePasswordRemoteDatasource _changePasswordRemoteDatasource;
  final SecureLocalStorage _secureLocalStorage;
  ChangePasswordRepositoryImpl(
      this._changePasswordRemoteDatasource, this._secureLocalStorage);

  @override
  Future<Either<Failure, String>> changePassword(
      String currentPassword, String password, String confirmPassword) async {
    try {
      final userId = await _secureLocalStorage.load(key: 'userId');
      final params = ChangePasswordModel(
          id: userId,
          currentPassword: currentPassword,
          password: password,
          confirmPassword: confirmPassword);
      final res = await _changePasswordRemoteDatasource.changePassword(params);
      if (res['status'] == 409) {
        return Left(Failure(res['message']));
      }
      return Right(res['message']);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }
}
