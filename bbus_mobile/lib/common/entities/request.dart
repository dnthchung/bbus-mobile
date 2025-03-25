import 'package:equatable/equatable.dart';

class RequestEntity extends Equatable {
  const RequestEntity({
    required this.requestId,
    required this.requestTypeId,
    required this.requestTypeName,
    required this.studentId,
    required this.studentName,
    required this.sendByUserId,
    required this.checkpointId,
    required this.checkpointName,
    required this.approvedByUserId,
    required this.approvedByName,
    required this.reason,
    required this.reply,
    required this.status,
  });

  final String requestId;
  final String requestTypeId;
  final String requestTypeName;
  final dynamic studentId;
  final dynamic studentName;
  final String sendByUserId;
  final String checkpointId;
  final String checkpointName;
  final String approvedByUserId;
  final String approvedByName;
  final String reason;
  final String reply;
  final String status;

  factory RequestEntity.fromJson(Map<String, dynamic> json) {
    return RequestEntity(
      requestId: json["requestId"] ?? "",
      requestTypeId: json["requestTypeId"] ?? "",
      requestTypeName: json["requestTypeName"] ?? "",
      studentId: json["studentId"],
      studentName: json["studentName"],
      sendByUserId: json["sendByUserId"] ?? "",
      checkpointId: json["checkpointId"] ?? "",
      checkpointName: json["checkpointName"] ?? "",
      approvedByUserId: json["approvedByUserId"] ?? "",
      approvedByName: json["approvedByName"] ?? "",
      reason: json["reason"] ?? "",
      reply: json["reply"] ?? "",
      status: json["status"] ?? "",
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
        checkpointId,
        checkpointName,
        approvedByUserId,
        approvedByName,
        reason,
        reply,
        status,
      ];
}
