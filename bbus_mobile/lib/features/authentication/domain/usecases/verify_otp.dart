import 'package:bbus_mobile/core/errors/failures.dart';
import 'package:bbus_mobile/core/usecases/usecase.dart';
import 'package:bbus_mobile/features/authentication/domain/repository/auth_repository.dart';
import 'package:dartz/dartz.dart';

class VerifyOtp implements UseCase<String, VerifyOtpParams> {
  final AuthRepository _authRepository;
  VerifyOtp(this._authRepository);
  @override
  Future<Either<Failure, String>> call(VerifyOtpParams params) async {
    return await _authRepository.verifyOtp(
        phone: params.phone, otp: params.otp);
  }
}

class VerifyOtpParams {
  final String phone;
  final String otp;
  VerifyOtpParams(this.phone, this.otp);
}
