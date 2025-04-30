import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

class DailyScheduleEntity extends Equatable {
  int? id;
  String? date;
  EventDetail? pickup;
  EventDetail? drop;
  EventDetail? attendance;

  DailyScheduleEntity(
      {this.id, this.date, this.pickup, this.drop, this.attendance});

  DailyScheduleEntity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    pickup = json['pickup'] != null
        ? new EventDetail.fromJson(json['pickup'])
        : null;
    drop = json['drop'] != null ? new EventDetail.fromJson(json['drop']) : null;
    attendance = json['attendance'] != null
        ? new EventDetail.fromJson(json['attendance'])
        : null;
  }
  DailyScheduleEntity copyWith({
    EventDetail? pickup,
    EventDetail? drop,
    EventDetail? attendance,
  }) {
    return DailyScheduleEntity(
      id: this.id,
      date: this.date,
      pickup: pickup ?? this.pickup,
      attendance: attendance ?? this.attendance,
      drop: drop ?? this.drop,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['date'] = this.date;
    if (this.pickup != null) {
      data['pickup'] = this.pickup!.toJson();
    }
    if (this.drop != null) {
      data['drop'] = this.drop!.toJson();
    }
    if (this.attendance != null) {
      data['attendance'] = this.attendance!.toJson();
    }
    return data;
  }

  @override
  // TODO: implement props
  List<Object?> get props => [id, date, pickup, drop, attendance];
}

class EventDetail {
  String? time;
  String? timeLeave;
  String? address;
  String? verifier;

  EventDetail({this.time, this.address, this.verifier, this.timeLeave});
  factory EventDetail.withFormattedTime({
    String? time,
    String? timeLeave,
    String? address,
    String? verifier,
  }) {
    return EventDetail(
      time: _formatTime(time),
      timeLeave: _formatTime(timeLeave),
      address: address,
      verifier: verifier,
    );
  }
  static String? _formatTime(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    try {
      final parsed = DateTime.parse(raw);
      return DateFormat('HH:mm').format(parsed);
    } catch (_) {
      return raw;
    }
  }

  EventDetail copyWith({String? time, String? timeLeave}) {
    return EventDetail.withFormattedTime(
        time: time ?? this.time,
        timeLeave: timeLeave ?? this.timeLeave,
        address: this.address,
        verifier: this.verifier);
  }

  EventDetail.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    address = json['address'];
    verifier = json['verifier'];
    verifier = json['timeLeave'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['time'] = this.time;
    data['address'] = this.address;
    data['verifier'] = this.verifier;
    data['timeLeave'] = this.verifier;
    return data;
  }
}

List<DailyScheduleEntity> mockDailySchedules = [
  DailyScheduleEntity(
    id: 1,
    date: "2025-03-03",
    pickup: EventDetail(
        time: "07:30",
        address: "123 S Maine Ave, Pine Hills",
        verifier: 'Andrew'),
    drop: EventDetail(
        time: "17:10",
        address: "123 S Maine Ave, Pine Hills",
        verifier: 'Sofia'),
    attendance: EventDetail(
        time: "08:00",
        address: "Haledon Public High School",
        verifier: 'Andrew'),
  ),
  DailyScheduleEntity(
    id: 2,
    date: "2025-03-02",
    pickup: EventDetail(time: "07:40", address: "456 Oak Street, Springfield"),
    drop: EventDetail(time: "16:50", address: "456 Oak Street, Springfield"),
    attendance: EventDetail(time: "08:15", address: "Springfield High School"),
  ),
  DailyScheduleEntity(
    id: 3,
    date: "2025-02-28",
    pickup: EventDetail(time: "07:45", address: "789 Elm St, Fairview"),
    drop: EventDetail(time: "17:30", address: "789 Elm St, Fairview"),
    attendance: EventDetail(time: "08:10", address: "Fairview Academy"),
  ),
  DailyScheduleEntity(
    id: 4,
    date: "2024-03-04",
    pickup: EventDetail(time: "07:35", address: "567 Maple Ave, Oakwood"),
    drop: EventDetail(time: "17:00", address: "567 Maple Ave, Oakwood"),
    attendance: EventDetail(time: "08:05", address: "Oakwood High"),
  ),
  DailyScheduleEntity(
    id: 5,
    date: "2024-03-05",
    pickup: EventDetail(time: "07:50", address: "901 Cedar Lane, Brookfield"),
    drop: EventDetail(time: "16:45", address: "901 Cedar Lane, Brookfield"),
    attendance: EventDetail(time: "08:20", address: "Brookfield Academy"),
  ),
];
