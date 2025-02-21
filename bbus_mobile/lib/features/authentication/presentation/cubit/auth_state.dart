part of 'auth_cubit.dart';

abstract class AuthState {
  const AuthState();
}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthSucess extends AuthState {
  final bool isLoggedIn;
  const AuthSucess(this.isLoggedIn);
}

final class AuthFailure extends AuthState {
  final String message;
  const AuthFailure(this.message);
}
