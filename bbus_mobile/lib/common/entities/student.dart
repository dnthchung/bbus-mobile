import 'package:equatable/equatable.dart';

class StudentEntity extends Equatable {
  String? studentId;
  String? teacherId;
  DateTime? date;
  bool? direction;
  String? checkpointId;
  String? busId;
  String? status;
  dynamic checkin;
  dynamic checkout;

  StudentEntity({
    this.studentId,
    this.teacherId,
    this.date,
    this.direction,
    this.checkpointId,
    this.busId,
    this.status,
    this.checkin,
    this.checkout,
  });

  StudentEntity copyWith({
    String? studentId,
    String? teacherId,
    DateTime? date,
    bool? direction,
    String? checkpointId,
    String? busId,
    String? status,
    dynamic? checkin,
    dynamic? checkout,
  }) {
    return StudentEntity(
      studentId: studentId ?? this.studentId,
      teacherId: teacherId ?? this.teacherId,
      date: date ?? this.date,
      direction: direction ?? this.direction,
      checkpointId: checkpointId ?? this.checkpointId,
      busId: busId ?? this.busId,
      status: status ?? this.status,
      checkin: checkin ?? this.checkin,
      checkout: checkout ?? this.checkout,
    );
  }

  factory StudentEntity.fromJson(Map<String, dynamic> json) {
    return StudentEntity(
      studentId: json["studentId"] ?? "",
      teacherId: json["teacherId"] ?? "",
      date: DateTime.tryParse(json["date"] ?? ""),
      direction: json["direction"] ?? false,
      checkpointId: json["checkpointId"] ?? "",
      busId: json["busId"] ?? "",
      status: json["status"] ?? "",
      checkin: json["checkin"],
      checkout: json["checkout"],
    );
  }

  @override
  List<Object?> get props => [
        studentId,
        teacherId,
        date,
        direction,
        checkpointId,
        busId,
        status,
        checkin,
        checkout,
      ];
}
