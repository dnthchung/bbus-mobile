import 'package:bbus_mobile/core/usecases/usecase.dart';
import 'package:bbus_mobile/core/utils/failures_converter.dart';
import 'package:bbus_mobile/core/utils/logger.dart';
import 'package:bbus_mobile/features/authentication/domain/entities/user.dart';
import 'package:bbus_mobile/features/authentication/domain/usecases/check_logged_in_status_usecase.dart';
import 'package:bbus_mobile/features/authentication/domain/usecases/login_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUsecase _loginUsecase;
  final CheckLoggedInStatusUsecase _checkLoggedInStatusUsecase;
  AuthCubit(this._loginUsecase, this._checkLoggedInStatusUsecase)
      : super(AuthInitial());
  Future<void> login(String phone, String password) async {
    emit(AuthLoginLoading());
    final result =
        await _loginUsecase.call(LoginParams(phone: phone, password: password));
    logger.i(result);
    result.fold((l) => emit(AuthLoginFailure(mapFailureToMessage(l))),
        (r) => emit(AuthLoginSucess(r)));
  }

  Future<void> checkLoggedInStatus() async {
    emit(AuthLoggedInStatusLoading());
    final result = await _checkLoggedInStatusUsecase.call(NoParams());
    result.fold((l) => emit(AuthLoggedInStatusFailure(mapFailureToMessage(l))),
        (r) => emit(AuthLoggedInStatusSuccess(r)));
  }
}
