import 'package:equatable/equatable.dart';

class ChildEntity extends Equatable {
  ChildEntity({
    required this.id,
    required this.rollNumber,
    required this.name,
    required this.avatar,
    required this.dob,
    required this.address,
    required this.gender,
    required this.status,
    required this.parentId,
    required this.parent,
    required this.checkpointId,
    required this.checkpointName,
    required this.checkpointDescription,
  });

  final String? id;
  final String? rollNumber;
  final String? name;
  final dynamic avatar;
  final dynamic dob;
  final dynamic address;
  final dynamic gender;
  final dynamic status;
  final dynamic parentId;
  final dynamic parent;
  final dynamic checkpointId;
  final dynamic checkpointName;
  final dynamic checkpointDescription;

  ChildEntity copyWith({
    String? id,
    String? rollNumber,
    String? name,
    dynamic? avatar,
    dynamic? dob,
    dynamic? address,
    dynamic? gender,
    dynamic? status,
    dynamic? parentId,
    dynamic? parent,
    dynamic? checkpointId,
    dynamic? checkpointName,
    dynamic? checkpointDescription,
  }) {
    return ChildEntity(
      id: id ?? this.id,
      rollNumber: rollNumber ?? this.rollNumber,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      dob: dob ?? this.dob,
      address: address ?? this.address,
      gender: gender ?? this.gender,
      status: status ?? this.status,
      parentId: parentId ?? this.parentId,
      parent: parent ?? this.parent,
      checkpointId: checkpointId ?? this.checkpointId,
      checkpointName: checkpointName ?? this.checkpointName,
      checkpointDescription:
          checkpointDescription ?? this.checkpointDescription,
    );
  }

  factory ChildEntity.fromJson(Map<String, dynamic> json) {
    return ChildEntity(
      id: json["id"],
      rollNumber: json["rollNumber"],
      name: json["name"],
      avatar: json["avatar"],
      dob: json["dob"],
      address: json["address"],
      gender: json["gender"],
      status: json["status"],
      parentId: json["parentId"],
      parent: json["parent"],
      checkpointId: json["checkpointId"],
      checkpointName: json["checkpointName"],
      checkpointDescription: json["checkpointDescription"],
    );
  }

  @override
  List<Object?> get props => [
        id,
        rollNumber,
        name,
        avatar,
        dob,
        address,
        gender,
        status,
        parentId,
        parent,
        checkpointId,
        checkpointName,
        checkpointDescription,
      ];
}
