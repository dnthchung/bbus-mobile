import 'package:bbus_mobile/config/injector/injector.dart';
import 'package:bbus_mobile/features/authentication/domain/usecases/login_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());
  Future<void> _login(String username, String password) async {
    emit(AuthLoading());
    final res = await sl<LoginUsecase>()
        .call(LoginParams(username: username, password: password));
    res.fold((l) => emit(AuthFailure(l.message)), (r) => emit(AuthSucess(r)));
  }
}
