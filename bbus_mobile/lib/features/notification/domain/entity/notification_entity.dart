import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable {
  final String id;
  final String title;
  final String body;
  final DateTime timestamp;

  NotificationEntity({
    required this.id,
    required this.title,
    required this.body,
    required this.timestamp,
  });

  factory NotificationEntity.fromJson(Map<String, dynamic> json) {
    return NotificationEntity(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  @override
  List<Object> get props => [id, title, body, timestamp];
}
