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
    required String? role,
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
          role: role,
        );
  UserModel copyWith({
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
    return UserModel(
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

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'],
      username: json['username'],
      name: json['name'],
      gender: json['gender'],
      dob: json['dob'].toString(),
      email: json['email'],
      avatar: json['avatar'],
      phone: json['phone'],
      address: json['address'],
      status: json['status'],
      role: json['role'],
    );
  }
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.userId ?? '';
    data['username'] = this.username ?? '';
    data['name'] = this.name ?? '';
    data['gender'] = this.gender ?? '';
    data['dob'] = this.dob ?? '';
    data['email'] = this.email ?? '';
    data['avatar'] = this.avatar ?? '';
    data['phone'] = this.phone ?? "";
    data['address'] = this.address;
    data['status'] = this.status;
    data['role'] = this.role;
    return data;
  }
}
