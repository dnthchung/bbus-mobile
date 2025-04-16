import 'package:equatable/equatable.dart';

class Failure extends Equatable {
  final String message;
  const Failure([this.message = 'An unexpected error occurred,']);

  @override
  // TODO: implement props
  List<Object?> get props => [message];
}

class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

class EmptyFailure extends Failure {}
