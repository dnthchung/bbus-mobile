import 'package:equatable/equatable.dart';

class StudentEntity extends Equatable {
  String? id;
  String? studentId;
  String? studentName;
  String? rollNumber;
  String? avatarUrl;
  DateTime? dob;
  String? direction;
  String? status;
  dynamic checkin;
  dynamic checkout;
  String? checkpointId;
  String? checkpointName;
  String? parentName;
  String? parentPhone;

  StudentEntity({
    this.id,
    this.studentId,
    this.studentName,
    this.rollNumber,
    this.avatarUrl,
    this.dob,
    this.direction,
    this.status,
    this.checkin,
    this.checkout,
    this.checkpointId,
    this.checkpointName,
    this.parentName,
    this.parentPhone,
  });

  StudentEntity copyWith({
    String? id,
    String? studentId,
    String? studentName,
    String? rollNumber,
    String? avatarUrl,
    DateTime? dob,
    String? direction,
    String? status,
    dynamic? checkin,
    dynamic? checkout,
    String? checkpointId,
    String? checkpointName,
    String? parentName,
    String? parentPhone,
  }) {
    return StudentEntity(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      studentName: studentName ?? this.studentName,
      rollNumber: rollNumber ?? this.rollNumber,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      dob: dob ?? this.dob,
      direction: direction ?? this.direction,
      status: status ?? this.status,
      checkin: checkin ?? this.checkin,
      checkout: checkout ?? this.checkout,
      checkpointId: checkpointId ?? this.checkpointId,
      checkpointName: checkpointName ?? this.checkpointName,
      parentName: parentName ?? this.parentName,
      parentPhone: parentPhone ?? this.parentPhone,
    );
  }

  factory StudentEntity.fromJson(Map<String, dynamic> json) {
    return StudentEntity(
      id: json["id"] ?? "",
      studentId: json["studentId"] ?? "",
      studentName: json["studentName"] ?? "",
      rollNumber: json["rollNumber"] ?? "",
      avatarUrl: json["avatarUrl"] ?? "",
      dob: DateTime.tryParse(json["dob"] ?? ""),
      direction: json["direction"] ?? "",
      status: json["status"] ?? "",
      checkin: json["checkin"],
      checkout: json["checkout"],
      checkpointId: json["checkpointId"] ?? "",
      checkpointName: json["checkpointName"] ?? "",
      parentName: json["parentName"] ?? "",
      parentPhone: json["parentPhone"] ?? "",
    );
  }

  @override
  List<Object?> get props => [
        id,
        studentId,
        studentName,
        rollNumber,
        avatarUrl,
        dob,
        direction,
        status,
        checkin,
        checkout,
        checkpointId,
        checkpointName,
        parentName,
        parentPhone,
      ];
}
