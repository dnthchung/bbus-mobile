import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final int? userId;
  final String? fullName;
  final String? username;
  final String? password;
  const UserEntity({this.userId, this.fullName, this.username, this.password});

  @override
  // TODO: implement props
  List<Object?> get props {
    return [userId, fullName, username, password];
  }
}
