import 'package:bbus_mobile/features/notification/domain/entity/notification_entity.dart';

abstract class NotificationRepository {
  Future<void> initNotifications();
  Stream<NotificationEntity> get notificationStream;
}
