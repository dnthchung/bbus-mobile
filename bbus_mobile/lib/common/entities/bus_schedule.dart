import 'package:equatable/equatable.dart';

class BusScheduleEntity extends Equatable {
  String? id;
  String? busId;
  String? name;
  String? licensePlate;
  DateTime? date;
  String? driverId;
  String? driverName;
  String? assistantId;
  String? assistantName;
  String? direction;
  String? route;
  String? routeId;
  String? busScheduleStatus;
  DateTime? createdAt;
  DateTime? updatedAt;

  BusScheduleEntity({
    this.id,
    this.busId,
    this.name,
    this.licensePlate,
    this.date,
    this.driverId,
    this.driverName,
    this.assistantId,
    this.assistantName,
    this.direction,
    this.route,
    this.routeId,
    this.busScheduleStatus,
    this.createdAt,
    this.updatedAt,
  });

  BusScheduleEntity copyWith({
    String? id,
    String? busId,
    String? name,
    String? licensePlate,
    DateTime? date,
    String? driverId,
    String? driverName,
    String? assistantId,
    String? assistantName,
    String? direction,
    String? route,
    String? routeId,
    String? busScheduleStatus,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BusScheduleEntity(
      id: id ?? this.id,
      busId: busId ?? this.busId,
      name: name ?? this.name,
      licensePlate: licensePlate ?? this.licensePlate,
      date: date ?? this.date,
      driverId: driverId ?? this.driverId,
      driverName: driverName ?? this.driverName,
      assistantId: assistantId ?? this.assistantId,
      assistantName: assistantName ?? this.assistantName,
      direction: direction ?? this.direction,
      route: route ?? this.route,
      routeId: routeId ?? this.routeId,
      busScheduleStatus: busScheduleStatus ?? this.busScheduleStatus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory BusScheduleEntity.fromJson(Map<String, dynamic> json) {
    return BusScheduleEntity(
      id: json["id"] ?? "",
      busId: json["busId"] ?? "",
      name: json["name"] ?? "",
      licensePlate: json["licensePlate"] ?? "",
      date: DateTime.tryParse(json["date"] ?? ""),
      driverId: json["driverId"] ?? "",
      driverName: json["driverName"] ?? "",
      assistantId: json["assistantId"] ?? "",
      assistantName: json["assistantName"] ?? "",
      direction: json["direction"] ?? "",
      route: json["route"] ?? "",
      routeId: json["routeId"] ?? "",
      busScheduleStatus: json["busScheduleStatus"] ?? "",
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
    );
  }

  @override
  List<Object?> get props => [
        id,
        busId,
        name,
        licensePlate,
        date,
        driverId,
        driverName,
        assistantId,
        assistantName,
        direction,
        route,
        routeId,
        busScheduleStatus,
        createdAt,
        updatedAt,
      ];
}
