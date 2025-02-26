import 'package:bbus_mobile/core/errors/failures.dart';
import 'package:bbus_mobile/features/authentication/domain/entities/user.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> login(
      {required String phone, required String password});
  Future<Either<Failure, UserEntity>> checkLoggedInStatus();
  Future<Either<Failure, void>> logout();
}
