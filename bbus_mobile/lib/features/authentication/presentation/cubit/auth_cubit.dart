import 'package:bbus_mobile/common/cubit/current_user/current_user_cubit.dart';
import 'package:bbus_mobile/common/notifications/notification_service.dart';
import 'package:bbus_mobile/config/injector/injector.dart';
import 'package:bbus_mobile/core/usecases/usecase.dart';
import 'package:bbus_mobile/core/utils/logger.dart';
import 'package:bbus_mobile/common/entities/user.dart';
import 'package:bbus_mobile/features/authentication/domain/usecases/check_logged_in_status_usecase.dart';
import 'package:bbus_mobile/features/authentication/domain/usecases/login_usecase.dart';
import 'package:bbus_mobile/features/authentication/domain/usecases/logout_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUsecase _loginUsecase;
  final CheckLoggedInStatusUsecase _checkLoggedInStatusUsecase;
  final CurrentUserCubit _currentUserCubit;
  final LogoutUsecase _logoutUsecase;
  AuthCubit(this._loginUsecase, this._checkLoggedInStatusUsecase,
      this._currentUserCubit, this._logoutUsecase)
      : super(AuthInitial());
  Future<void> login(String phone, String password) async {
    emit(AuthLoginLoading());
    final result =
        await _loginUsecase.call(LoginParams(phone: phone, password: password));
    logger.i(result);
    result.fold((l) => emit(AuthLoginFailure(l.message)), (r) {
      _currentUserCubit.updateUser(r);
      emit(AuthLoginSucess(r));
    });
  }

  Future<void> checkLoggedInStatus() async {
    emit(AuthLoggedInStatusLoading());
    final result = await _checkLoggedInStatusUsecase.call(NoParams());
    result.fold((l) {
      _currentUserCubit.updateUser(null);
      emit(AuthLoggedInStatusFailure(l.message));
    }, (r) {
      _currentUserCubit.updateUser(r);
      emit(AuthLoggedInStatusSuccess(r));
    });
  }

  Future<void> logout() async {
    emit(AuthLogoutLoading());
    sl<NotificationService>().closeBox();
    final result = await _logoutUsecase.call(NoParams());
    result.fold((l) {
      emit(AuthLogoutFailure(l.message));
    }, (r) {
      _currentUserCubit.updateUser(null);
      emit(const AuthLogoutSuccess('Logout Success'));
    });
  }
}
