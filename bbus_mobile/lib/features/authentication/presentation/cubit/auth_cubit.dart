import 'package:bbus_mobile/core/usecases/usecase.dart';
import 'package:bbus_mobile/core/utils/failures_converter.dart';
import 'package:bbus_mobile/features/authentication/domain/usecases/check_logged_in_status_usecase.dart';
import 'package:bbus_mobile/features/authentication/domain/usecases/login_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUsecase _loginUsecase;
  final CheckLoggedInStatusUsecase _checkLoggedInStatusUsecase;
  AuthCubit(this._loginUsecase, this._checkLoggedInStatusUsecase)
      : super(AuthInitial());
  Future<void> login(String phone, String password) async {
    emit(AuthLoading());
    final result =
        await _loginUsecase.call(LoginParams(phone: phone, password: password));
    result.fold((l) => emit(AuthFailure(mapFailureToMessage(l))),
        (r) => emit(AuthSucess('Login Success')));
  }

  Future<void> checkLoggedInStatus() async {
    emit(AuthLoading());
    final result = await _checkLoggedInStatusUsecase.call(NoParams());
    result.fold((l) => emit(AuthFailure(mapFailureToMessage(l))),
        (r) => emit(AuthSucess('User is siggened in')));
  }
}
