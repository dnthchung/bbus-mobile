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
  final String? role;
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
        "role": null*/

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
      this.role});
  UserEntity copyWith({
    String? userId,
    String? username,
    String? name,
    String? gender,
    String? dob,
    String? email,
    String? avatar,
    String? phone,
    String? address,
    String? status,
    String? role,
  }) {
    return UserEntity(
      userId: userId ?? this.userId,
      username: username ?? this.username,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      dob: dob ?? this.dob,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      status: status ?? this.status,
      role: role ?? this.role,
    );
  }

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
      role
    ];
  }
}
