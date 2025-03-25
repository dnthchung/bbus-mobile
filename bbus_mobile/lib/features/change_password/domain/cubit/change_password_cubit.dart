import 'package:bbus_mobile/features/change_password/domain/usecase/change_password_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'change_password_state.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  final ChangePasswordUsecase _changePasswordUsecase;
  ChangePasswordCubit(this._changePasswordUsecase)
      : super(ChangePasswordInitial());
  Future<void> changePassword(
      String currentPassword, String password, String confirmPassword) async {
    emit(ChangePasswordLoading());
    final res = await _changePasswordUsecase(ChangePasswordParams(
        currentPassword: currentPassword,
        password: password,
        confirmPassword: confirmPassword));
    res.fold((l) => emit(ChangePasswordFailure(l.message)),
        (r) => emit(ChangePasswordSuccess(r)));
  }
}
