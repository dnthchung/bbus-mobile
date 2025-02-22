part of 'auth_cubit.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthSucess extends AuthState {
  final String message;
  const AuthSucess(this.message);
  @override
  // TODO: implement props
  List<Object?> get props => super.props;
}

final class AuthFailure extends AuthState {
  final String message;
  const AuthFailure(this.message);
  @override
  // TODO: implement props
  List<Object?> get props => [message];
}
