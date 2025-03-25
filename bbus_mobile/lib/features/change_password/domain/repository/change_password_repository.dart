import 'package:bbus_mobile/core/errors/failures.dart';
import 'package:bbus_mobile/features/change_password/data/models/change_password_model.dart';
import 'package:dartz/dartz.dart';

abstract class ChangePasswordRepository {
  Future<Either<Failure, String>> changePassword(
      String currentPassword, String password, String confirmPassword);
}
