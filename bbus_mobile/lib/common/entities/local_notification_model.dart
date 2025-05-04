import 'package:hive/hive.dart';
part 'local_notification_model.g.dart';

@HiveType(typeId: 0)
class LocalNotificationModel {
  @HiveField(0)
  final String title;
  @HiveField(1)
  final String body;
  @HiveField(2)
  final DateTime timestamp;
  @HiveField(3)
  final bool isRead;
  @HiveField(4)
  final String key;
  LocalNotificationModel({
    required this.title,
    required this.body,
    required this.timestamp,
    this.isRead = false,
    required this.key,
  });
}
