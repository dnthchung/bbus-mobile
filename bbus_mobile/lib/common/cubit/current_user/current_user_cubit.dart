import 'package:bbus_mobile/common/entities/user.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'current_user_state.dart';

class CurrentUserCubit extends Cubit<CurrentUserState> {
  CurrentUserCubit() : super(CurrentUserInitial());
  void updateUser(UserEntity? user) {
    if (user == null) {
      emit(CurrentUserInitial());
    } else
      emit(CurrentUserLoggedIn(user));
  }
}
