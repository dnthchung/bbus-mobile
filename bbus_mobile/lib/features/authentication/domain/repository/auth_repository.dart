import 'package:bbus_mobile/core/errors/failures.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepository {
  Future<Either<Failure, bool>> login({required String username, required String password});
}
