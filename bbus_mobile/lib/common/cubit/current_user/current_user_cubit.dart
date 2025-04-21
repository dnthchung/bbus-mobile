import 'dart:typed_data';

import 'package:bbus_mobile/common/entities/user.dart';
import 'package:bbus_mobile/config/injector/injector.dart';
import 'package:bbus_mobile/core/utils/logger.dart';
import 'package:bbus_mobile/features/authentication/data/datasources/auth_remote_datasource.dart';
import 'package:bbus_mobile/features/authentication/data/models/user_model.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'current_user_state.dart';

class CurrentUserCubit extends Cubit<CurrentUserState> {
  CurrentUserCubit() : super(CurrentUserInitial());
  void updateUser(UserEntity? user) {
    if (user == null) {
      emit(CurrentUserInitial());
    } else {
      logger.i('current user logged in');
      emit(CurrentUserLoggedIn(user));
    }
  }

  void updateProfile(UserEntity user) async {
    await sl<AuthRemoteDatasource>().updateUserProfile(UserModel(
        userId: user.userId,
        username: user.username,
        name: user.name,
        gender: user.gender,
        dob: user.dob,
        email: user.email,
        avatar: user.avatar ?? '',
        phone: user.phone,
        address: user.address,
        status: 'ACTIVE',
        role: user.role));
    emit(CurrentUserUpdated(user));
    emit(CurrentUserLoggedIn(user));
  }

  void updateAvatar(Uint8List? imageBytes) async {
    final res = await sl<AuthRemoteDatasource>().updateAvatar(imageBytes!);
    logger.i(res);
  }
}
