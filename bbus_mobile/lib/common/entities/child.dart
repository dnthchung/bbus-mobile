import 'package:equatable/equatable.dart';

class ChildEntity extends Equatable {
  ChildEntity({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.status,
    required this.age,
    required this.avatar,
  });

  final String id;
  final String name;
  final String address;
  final String latitude;
  final String longitude;
  final String status;
  final String age;
  final String avatar;

  factory ChildEntity.fromJson(Map<String, dynamic> json) {
    return ChildEntity(
      id: json["id"] ?? "",
      name: json["name"] ?? "",
      address: json["address"] ?? "",
      latitude: json["latitude"] ?? "",
      longitude: json["longitude"] ?? "",
      status: json["status"] ?? "",
      age: json["age"] ?? "",
      avatar: json["avatar"] ?? "",
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        address,
        latitude,
        longitude,
        status,
        age,
        avatar,
      ];
}
