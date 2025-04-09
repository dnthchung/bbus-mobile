import 'package:equatable/equatable.dart';

class BusEntity extends Equatable {
  BusEntity({
    this.id,
    this.licensePlate,
    this.name,
    this.driverId,
    this.driverName,
    this.driverPhone,
    this.assistantId,
    this.assistantName,
    this.assistantPhone,
    this.amountOfStudents,
    this.routeId,
    this.routeCode,
    this.espId,
    this.cameraFacesluice,
  });

  String? id;
  dynamic licensePlate;
  String? name;
  dynamic driverId;
  dynamic driverName;
  dynamic driverPhone;
  dynamic assistantId;
  dynamic assistantName;
  dynamic assistantPhone;
  int? amountOfStudents;
  String? routeId;
  dynamic routeCode;
  dynamic espId;
  dynamic cameraFacesluice;

  BusEntity copyWith({
    String? id,
    dynamic? licensePlate,
    String? name,
    dynamic? driverId,
    dynamic? driverName,
    dynamic? driverPhone,
    dynamic? assistantId,
    dynamic? assistantName,
    dynamic? assistantPhone,
    int? amountOfStudents,
    String? routeId,
    dynamic? routeCode,
    dynamic? espId,
    dynamic? cameraFacesluice,
  }) {
    return BusEntity(
      id: id ?? this.id,
      licensePlate: licensePlate ?? this.licensePlate,
      name: name ?? this.name,
      driverId: driverId ?? this.driverId,
      driverName: driverName ?? this.driverName,
      driverPhone: driverPhone ?? this.driverPhone,
      assistantId: assistantId ?? this.assistantId,
      assistantName: assistantName ?? this.assistantName,
      assistantPhone: assistantPhone ?? this.assistantPhone,
      amountOfStudents: amountOfStudents ?? this.amountOfStudents,
      routeId: routeId ?? this.routeId,
      routeCode: routeCode ?? this.routeCode,
      espId: espId ?? this.espId,
      cameraFacesluice: cameraFacesluice ?? this.cameraFacesluice,
    );
  }

  factory BusEntity.fromJson(Map<String, dynamic> json) {
    return BusEntity(
      id: json["id"] ?? "",
      licensePlate: json["licensePlate"],
      name: json["name"] ?? "",
      driverId: json["driverId"],
      driverName: json["driverName"],
      driverPhone: json["driverPhone"],
      assistantId: json["assistantId"],
      assistantName: json["assistantName"],
      assistantPhone: json["assistantPhone"],
      amountOfStudents: json["amountOfStudents"] ?? 0,
      routeId: json["routeId"] ?? "",
      routeCode: json["routeCode"],
      espId: json["espId"],
      cameraFacesluice: json["cameraFacesluice"],
    );
  }

  @override
  List<Object?> get props => [
        id,
        licensePlate,
        name,
        driverId,
        driverName,
        driverPhone,
        assistantId,
        assistantName,
        assistantPhone,
        amountOfStudents,
        routeId,
        routeCode,
        espId,
        cameraFacesluice,
      ];
}
