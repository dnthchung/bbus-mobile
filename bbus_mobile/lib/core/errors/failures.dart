import 'package:equatable/equatable.dart';

class Failure extends Equatable {
  @override
  List<Object> get props => [];
}

class ServerFailure extends Failure {}

class CacheFailure extends Failure {}

class EmptyFailure extends Failure {}

class CredentialFailure extends Failure {}

class DuplicateEmailFailure extends Failure {}

class PasswordNotMatchFailure extends Failure {}

class InvalidEmailFailure extends Failure {}

class InvalidPasswordFailure extends Failure {}

class AuthorizationFailure extends Failure {}
