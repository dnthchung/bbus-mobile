import 'package:bbus_mobile/core/errors/failures.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepository {
  Future<Either<Failure, Map<String, dynamic>>> login(
      {required String phone, required String password});
  Future<Either<Failure, bool>> checkLoggedInStatus();
}
