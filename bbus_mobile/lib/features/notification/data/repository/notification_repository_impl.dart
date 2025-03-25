import 'package:bbus_mobile/features/notification/domain/entity/notification_entity.dart';
import 'package:bbus_mobile/features/notification/domain/repository/notification_repository.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:async';

class NotificationRepositoryImpl implements NotificationRepository {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final StreamController<NotificationEntity> _controller =
      StreamController.broadcast();

  NotificationRepositoryImpl() {
    _init();
  }

  Future<void> _init() async {
    await _firebaseMessaging.requestPermission();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = NotificationEntity.fromJson({
        'id': message.messageId,
        'title': message.notification?.title ?? 'No Title',
        'body': message.notification?.body ?? 'No Body',
      });
      _controller.add(notification);
    });
  }

  @override
  Stream<NotificationEntity> get notificationStream => _controller.stream;

  @override
  Future<void> initNotifications() async {
    await _init();
  }
}
