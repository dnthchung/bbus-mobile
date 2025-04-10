import 'package:equatable/equatable.dart';

class BusScheduleEntity extends Equatable {
  String? id;
  String? busId;
  String? name;
  DateTime? date;
  String? driverId;
  String? driverName;
  String? assistantId;
  String? assistantName;
  String? route;
  DateTime? createdAt;
  DateTime? updatedAt;

  BusScheduleEntity({
    this.id,
    this.busId,
    this.name,
    this.date,
    this.driverId,
    this.driverName,
    this.assistantId,
    this.assistantName,
    this.route,
    this.createdAt,
    this.updatedAt,
  });

  BusScheduleEntity copyWith({
    String? id,
    String? busId,
    String? name,
    DateTime? date,
    String? driverId,
    String? driverName,
    String? assistantId,
    String? assistantName,
    String? route,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BusScheduleEntity(
      id: id ?? this.id,
      busId: busId ?? this.busId,
      name: name ?? this.name,
      date: date ?? this.date,
      driverId: driverId ?? this.driverId,
      driverName: driverName ?? this.driverName,
      assistantId: assistantId ?? this.assistantId,
      assistantName: assistantName ?? this.assistantName,
      route: route ?? this.route,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory BusScheduleEntity.fromJson(Map<String, dynamic> json) {
    return BusScheduleEntity(
      id: json["id"] ?? "",
      busId: json["busId"] ?? "",
      name: json["name"] ?? "",
      date: DateTime.tryParse(json["date"] ?? ""),
      driverId: json["driverId"] ?? "",
      driverName: json["driverName"] ?? "",
      assistantId: json["assistantId"] ?? "",
      assistantName: json["assistantName"] ?? "",
      route: json["route"] ?? "",
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
    );
  }

  @override
  List<Object?> get props => [
        id,
        busId,
        name,
        date,
        driverId,
        driverName,
        assistantId,
        assistantName,
        route,
        createdAt,
        updatedAt,
      ];
}
