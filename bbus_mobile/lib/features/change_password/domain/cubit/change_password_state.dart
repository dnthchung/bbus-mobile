part of 'change_password_cubit.dart';

@immutable
sealed class ChangePasswordState {
  const ChangePasswordState();
}

final class ChangePasswordInitial extends ChangePasswordState {}

final class ChangePasswordLoading extends ChangePasswordState {}

final class ChangePasswordSuccess extends ChangePasswordState {
  final String message;
  const ChangePasswordSuccess(this.message);
}

final class ChangePasswordFailure extends ChangePasswordState {
  final String message;
  const ChangePasswordFailure(this.message);
}
