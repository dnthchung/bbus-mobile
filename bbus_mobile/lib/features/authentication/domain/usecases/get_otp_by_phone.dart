import 'package:bbus_mobile/core/errors/failures.dart';
import 'package:bbus_mobile/core/usecases/usecase.dart';
import 'package:bbus_mobile/features/authentication/domain/repository/auth_repository.dart';
import 'package:dartz/dartz.dart';

class GetOtpByPhone implements UseCase<bool, String> {
  final AuthRepository _authRepository;
  GetOtpByPhone(this._authRepository);
  @override
  Future<Either<Failure, bool>> call(String params) async {
    return await _authRepository.getOtp(params);
  }
}
