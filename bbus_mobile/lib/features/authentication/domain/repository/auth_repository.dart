import 'package:bbus_mobile/core/errors/failures.dart';
import 'package:bbus_mobile/common/entities/user.dart';
import 'package:bbus_mobile/features/authentication/data/models/reset_password_model.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> login(
      {required String phone, required String password});
  Future<Either<Failure, UserEntity>> checkLoggedInStatus();
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, bool>> getOtp(String phoneNumber);
  Future<Either<Failure, String>> verifyOtp(
      {required String phone, required String otp});
  Future<Either<Failure, bool>> resetPassword(ResetPasswordModel params);
}
