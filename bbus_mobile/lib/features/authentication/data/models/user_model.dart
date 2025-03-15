import 'package:bbus_mobile/common/entities/user.dart';

class UserModel extends UserEntity {
  UserModel({
    required String? userId,
    required String? username,
    required String? name,
    required String? gender,
    required String? dob,
    required String? email,
    required String? avatar,
    required String? phone,
    required String? address,
    required String? status,
    required String? roles,
  }) : super(
          userId: userId,
          username: username,
          name: name,
          gender: gender,
          dob: dob,
          email: email,
          avatar: avatar,
          phone: phone,
          address: address,
          status: status,
          roles: roles,
        );
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['id'].toString(),
      username: json['username'],
      name: json['name'],
      gender: json['gender'],
      dob: json['dob'],
      email: json['email'],
      avatar: json['avatar'],
      phone: json['phone'],
      address: json['address'],
      status: json['status'],
      roles: json['roles'],
    );
  }
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.userId;
    data['username'] = this.username;
    data['name'] = this.name;
    data['gender'] = this.gender;
    data['dob'] = this.dob;
    data['email'] = this.email;
    data['avatar'] = this.avatar;
    data['phone'] = this.phone;
    data['address'] = this.address;
    data['status'] = this.status;
    data['roles'] = this.roles;
    return data;
  }
}
