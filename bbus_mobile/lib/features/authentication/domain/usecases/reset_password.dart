import 'package:bbus_mobile/core/errors/failures.dart';
import 'package:bbus_mobile/core/usecases/usecase.dart';
import 'package:bbus_mobile/features/authentication/data/models/reset_password_model.dart';
import 'package:bbus_mobile/features/authentication/domain/repository/auth_repository.dart';
import 'package:dartz/dartz.dart';

class ResetPassword implements UseCase<bool, ResetPasswordModel> {
  final AuthRepository _authRepository;
  ResetPassword(this._authRepository);
  @override
  Future<Either<Failure, bool>> call(ResetPasswordModel params) async {
    return await _authRepository.resetPassword(params);
  }
}
