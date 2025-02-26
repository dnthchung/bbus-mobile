import 'package:bbus_mobile/core/errors/failures.dart';
import 'package:bbus_mobile/core/usecases/usecase.dart';
import 'package:bbus_mobile/features/authentication/domain/entities/user.dart';
import 'package:bbus_mobile/features/authentication/domain/repository/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class LoginUsecase implements UseCase<UserEntity, LoginParams> {
  final AuthRepository _authRepository;
  const LoginUsecase(this._authRepository);

  @override
  Future<Either<Failure, UserEntity>> call(LoginParams params) async {
    final result = await _authRepository.login(
        phone: params.phone, password: params.password);
    return result;
  }
}

class LoginParams extends Equatable {
  final String phone;
  final String password;
  const LoginParams({
    required this.phone,
    required this.password,
  });

  @override
  List<Object?> get props => [
        phone,
        password,
      ];
}
