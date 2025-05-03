import 'package:equatable/equatable.dart';

class CheckpointEntity extends Equatable {
  String? id;
  String? name;
  String? description;
  double? latitude;
  double? longitude;
  String? status;
  dynamic? time;

  CheckpointEntity({
    this.id,
    this.name,
    this.description,
    this.latitude,
    this.longitude,
    this.status,
    this.time,
  });

  factory CheckpointEntity.fromJson(Map<String, dynamic> json) {
    return CheckpointEntity(
      id: json["id"] ?? "",
      name: json["name"] ?? "",
      description: json["description"] ?? "",
      latitude: json["latitude"] != null
          ? double.tryParse(json["latitude"].toString())
          : null,
      longitude: json["longitude"] != null
          ? double.tryParse(json["longitude"].toString())
          : null,
      status: json["status"] ?? "",
      time: json["time"] ?? "",
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
        time,
      ];
}
