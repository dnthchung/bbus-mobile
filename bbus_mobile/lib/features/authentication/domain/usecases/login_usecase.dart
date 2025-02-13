import 'package:bbus_mobile/features/authentication/domain/entities/user.dart';
import 'package:bbus_mobile/features/authentication/domain/repository/auth_repository.dart';

class LoginUsecase {
  final AuthRepository repository;

  LoginUsecase({required this.repository});

  Future<UserEntity> call(String username, String password) {
    return repository.login(username, password);
  }
}
