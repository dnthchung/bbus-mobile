import 'package:equatable/equatable.dart';

class CheckpointEntity extends Equatable {
  CheckpointEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.status,
  });

  final String id;
  final String name;
  final String description;
  final String latitude;
  final String longitude;
  final String status;

  factory CheckpointEntity.fromJson(Map<String, dynamic> json) {
    return CheckpointEntity(
      id: json["id"] ?? "",
      name: json["name"] ?? "",
      description: json["description"] ?? "",
      latitude: json["latitude"] ?? "",
      longitude: json["longitude"] ?? "",
      status: json["status"] ?? "",
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        latitude,
        longitude,
        status,
      ];
}
