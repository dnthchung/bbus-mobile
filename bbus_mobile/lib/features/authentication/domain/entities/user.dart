import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final int? userId;
  final String? fullName;
  final String? username;
  final String? password;
  final String? phone;
  const UserEntity(
      {this.userId, this.fullName, this.username, this.password, this.phone});

  @override
  // TODO: implement props
  List<Object?> get props {
    return [userId, fullName, username, password, phone];
  }
}
