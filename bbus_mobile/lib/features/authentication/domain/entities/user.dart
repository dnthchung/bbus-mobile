import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final int? id;
  final String? fullName;
  final String? username;
  const UserEntity({this.id, this.fullName, this.username});

  @override
  // TODO: implement props
  List<Object?> get props {
    return [id, fullName, username];
  }
}
