part of 'auth_cubit.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

final class AuthInitial extends AuthState {}

final class AuthLoginLoading extends AuthState {}

final class AuthLoginSucess extends AuthState {
  final UserEntity data;
  const AuthLoginSucess(this.data);
  @override
  // TODO: implement props
  List<Object?> get props => [data];
}

final class AuthLoginFailure extends AuthState {
  final String message;
  const AuthLoginFailure(this.message);
  @override
  // TODO: implement props
  List<Object?> get props => [message];
}

class AuthLogoutLoading extends AuthState {}

class AuthLogoutSuccess extends AuthState {
  final String message;
  const AuthLogoutSuccess(this.message);
  @override
  List<Object?> get props => [message];
}

class AuthLogoutFailure extends AuthState {
  final String message;
  const AuthLogoutFailure(this.message);
  @override
  List<Object?> get props => [message];
}

final class AuthLoggedInStatusLoading extends AuthState {}

class AuthLoggedInStatusSuccess extends AuthState {
  final UserEntity data;
  const AuthLoggedInStatusSuccess(this.data);
  @override
  List<Object?> get props => [data];
}

class AuthLoggedInStatusFailure extends AuthState {
  final String message;
  const AuthLoggedInStatusFailure(this.message);
  @override
  List<Object?> get props => [message];
}
