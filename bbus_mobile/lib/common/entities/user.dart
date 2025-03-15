import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String? userId;
  final String? username;
  final String? name;
  final String? gender;
  final String? dob;
  final String? email;
  final String? avatar;
  final String? phone;
  final String? address;
  final String? status;
  final String? roles;
  final String? password;
  /*"id": 2,
        "username": null,
        "name": "parent",
        "gender": null,
        "dob": "2000-02-04",
        "email": "parent@gmail.com",
        "avatar": "string",
        "phone": "0912345672",
        "address": "72 An Dương",
        "status": null,
        "roles": null*/

  const UserEntity(
      {this.userId,
      this.name,
      this.username,
      this.password,
      this.phone,
      this.gender,
      this.dob,
      this.email,
      this.avatar,
      this.address,
      this.status,
      this.roles});

  @override
  // TODO: implement props
  List<Object?> get props {
    return [
      userId,
      name,
      username,
      password,
      phone,
      gender,
      dob,
      email,
      avatar,
      address,
      status,
      roles
    ];
  }
}
