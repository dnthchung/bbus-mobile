import 'package:bbus_mobile/core/errors/failures.dart';
import 'package:bbus_mobile/core/usecases/usecase.dart';
import 'package:bbus_mobile/features/change_password/domain/repository/change_password_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class ChangePasswordUsecase implements UseCase<String, ChangePasswordParams> {
  final ChangePasswordRepository _changePasswordRepository;
  const ChangePasswordUsecase(this._changePasswordRepository);
  @override
  Future<Either<Failure, String>> call(ChangePasswordParams params) async {
    return await _changePasswordRepository.changePassword(
        params.currentPassword, params.password, params.confirmPassword);
  }
}

class ChangePasswordParams extends Equatable {
  ChangePasswordParams({
    required this.currentPassword,
    required this.password,
    required this.confirmPassword,
  });

  final String currentPassword;
  final String password;
  final String confirmPassword;

  factory ChangePasswordParams.fromJson(Map<String, dynamic> json) {
    return ChangePasswordParams(
      currentPassword: json["currentPassword"] ?? "",
      password: json["password"] ?? "",
      confirmPassword: json["confirmPassword"] ?? "",
    );
  }

  @override
  List<Object?> get props => [
        currentPassword,
        password,
        confirmPassword,
      ];
}
