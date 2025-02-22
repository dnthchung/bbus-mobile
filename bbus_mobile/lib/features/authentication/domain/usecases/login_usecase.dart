import 'package:bbus_mobile/core/errors/failures.dart';
import 'package:bbus_mobile/core/usecases/usecase.dart';
import 'package:bbus_mobile/features/authentication/domain/repository/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class LoginUsecase implements UseCase<void, LoginParams> {
  final AuthRepository repository;
  const LoginUsecase(this.repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(LoginParams params) async {
    final res =
        await repository.login(phone: params.phone, password: params.password);
    return res;
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
