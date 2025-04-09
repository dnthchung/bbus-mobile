import 'package:equatable/equatable.dart';

class CheckpointEntity extends Equatable {
  String? id;
  String? name;
  String? description;
  String? latitude;
  String? longitude;
  String? status;

  CheckpointEntity({
    this.id,
    this.name,
    this.description,
    this.latitude,
    this.longitude,
    this.status,
  });

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
