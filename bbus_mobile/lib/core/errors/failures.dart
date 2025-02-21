import 'package:equatable/equatable.dart';

class Failure extends Equatable {
  final String message;
  const Failure(this.message);
  @override
  List<Object> get props => [];
}

// class ServerFailure extends Failure {}

// class CacheFailure extends Failure {}

// class EmptyFailure extends Failure {}

// class CredentialFailure extends Failure {}

// class DuplicateEmailFailure extends Failure {}

// class PasswordNotMatchFailure extends Failure {}

// class InvalidEmailFailure extends Failure {}

// class InvalidPasswordFailure extends Failure {}