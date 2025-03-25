import 'package:equatable/equatable.dart';

class RequestTypeEntity extends Equatable {
  const RequestTypeEntity({
    required this.requestTypeId,
    required this.requestTypeName,
  });

  final String requestTypeId;
  final String requestTypeName;

  factory RequestTypeEntity.fromJson(Map<String, dynamic> json) {
    return RequestTypeEntity(
      requestTypeId: json["requestTypeId"] ?? "",
      requestTypeName: json["requestTypeName"] ?? "",
    );
  }

  @override
  List<Object?> get props => [
        requestTypeId,
        requestTypeName,
      ];
}
