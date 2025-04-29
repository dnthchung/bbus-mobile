import 'package:equatable/equatable.dart';

class RequestEntity extends Equatable {
  RequestEntity({
    required this.requestId,
    required this.requestTypeId,
    required this.requestTypeName,
    required this.studentId,
    required this.studentName,
    required this.sendByUserId,
    required this.sendByName,
    required this.checkpointId,
    required this.checkpointName,
    required this.approvedByUserId,
    required this.approvedByName,
    required this.fromDate,
    required this.toDate,
    required this.reason,
    required this.reply,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  final String requestId;
  final String requestTypeId;
  final String requestTypeName;
  final String studentId;
  final String studentName;
  final String sendByUserId;
  final String sendByName;
  final dynamic checkpointId;
  final dynamic checkpointName;
  final dynamic approvedByUserId;
  final dynamic approvedByName;
  final DateTime? fromDate;
  final DateTime? toDate;
  final String reason;
  final dynamic reply;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory RequestEntity.fromJson(Map<String, dynamic> json) {
    return RequestEntity(
      requestId: json["requestId"] ?? "",
      requestTypeId: json["requestTypeId"] ?? "",
      requestTypeName: json["requestTypeName"] ?? "",
      studentId: json["studentId"] ?? "",
      studentName: json["studentName"] ?? "",
      sendByUserId: json["sendByUserId"] ?? "",
      sendByName: json["sendByName"] ?? "",
      checkpointId: json["checkpointId"],
      checkpointName: json["checkpointName"],
      approvedByUserId: json["approvedByUserId"],
      approvedByName: json["approvedByName"],
      fromDate: DateTime.tryParse(json["fromDate"] ?? ""),
      toDate: DateTime.tryParse(json["toDate"] ?? ""),
      reason: json["reason"] ?? "",
      reply: json["reply"],
      status: json["status"] ?? "",
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
    );
  }

  @override
  List<Object?> get props => [
        requestId,
        requestTypeId,
        requestTypeName,
        studentId,
        studentName,
        sendByUserId,
        sendByName,
        checkpointId,
        checkpointName,
        approvedByUserId,
        approvedByName,
        fromDate,
        toDate,
        reason,
        reply,
        status,
        createdAt,
        updatedAt,
      ];
}
