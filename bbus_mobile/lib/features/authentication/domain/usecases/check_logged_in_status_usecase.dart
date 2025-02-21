import 'package:bbus_mobile/config/injector/injector.dart';
import 'package:bbus_mobile/core/errors/failures.dart';
import 'package:bbus_mobile/core/usecases/usecase.dart';
import 'package:bbus_mobile/features/authentication/domain/repository/auth_repository.dart';
import 'package:dartz/dartz.dart';

class CheckLoggedInStatusUsecase implements UseCase<bool, NoParams> {
  final AuthRepository _authRepository;
  CheckLoggedInStatusUsecase(this._authRepository);
  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return await _authRepository.checkLoggedInStatus();
  }
}
