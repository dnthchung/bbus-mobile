import 'package:equatable/equatable.dart';

class ChildEntity extends Equatable {
  String? id;
  String? rollNumber;
  String? name;
  dynamic avatar;
  dynamic dob;
  dynamic address;
  dynamic gender;
  dynamic status;
  dynamic parentId;
  String? busId;
  String? busName;
  dynamic parent;
  dynamic checkpointId;
  dynamic checkpointName;
  dynamic checkpointDescription;

  ChildEntity({
    this.id,
    this.rollNumber,
    this.name,
    this.avatar,
    this.dob,
    this.address,
    this.gender,
    this.status,
    this.parentId,
    this.busId,
    this.busName,
    this.parent,
    this.checkpointId,
    this.checkpointName,
    this.checkpointDescription,
  });

  ChildEntity copyWith({
    String? id,
    String? rollNumber,
    String? name,
    String? avatar,
    String? dob,
    String? address,
    String? gender,
    String? status,
    String? parentId,
    String? busId,
    String? busName,
    String? parent,
    String? checkpointId,
    String? checkpointName,
    String? checkpointDescription,
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
      busId: busId ?? this.busId,
      busName: busName ?? this.busName,
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
      dob: json["dob"].toString(),
      address: json["address"],
      gender: json["gender"],
      status: json["status"],
      parentId: json["parentId"],
      busId: json["busId"],
      busName: json["busName"],
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
        busId,
        busName,
        parent,
        checkpointId,
        checkpointName,
        checkpointDescription,
      ];
}
