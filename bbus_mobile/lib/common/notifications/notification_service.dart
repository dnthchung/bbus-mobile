import 'dart:async';

import 'package:bbus_mobile/config/injector/injector.dart';
import 'package:bbus_mobile/core/cache/secure_local_storage.dart';
import 'package:bbus_mobile/core/utils/logger.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotif =
      FlutterLocalNotificationsPlugin();
  final SecureLocalStorage _secureStorage = sl<SecureLocalStorage>();
  final StreamController<RemoteMessage> _notificationStreamController =
      StreamController.broadcast();

  Stream<RemoteMessage> get notificationStream =>
      _notificationStreamController.stream;
  Future<void> init() async {
    // Request notification permissions
    await _messaging.requestPermission();

    // Initialize local notifications
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    const initSettings =
        InitializationSettings(android: androidSettings, iOS: iosSettings);

    await _localNotif.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    // Listen for foreground notifications
    FirebaseMessaging.onMessage.listen(_handleForegroundNotification);

    // Listen for notifications tapped when the app is in the background
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);
  }

  void _handleForegroundNotification(message) async {
    logger.i('message been sent');
    logger.i('Message without notification: ${message}');
    if (message.notification!.title == null &&
        message.notification!.body == null) {
      return;
    }
    var notifType = 'checkin';
    logger.i({
      'title': message.notification?.title,
      'body': message.notification?.body,
      'data': message.data,
    });
    final notification = message.notification;
    if (notification != null) {
      const androidDetails = AndroidNotificationDetails(
        'default_channel', // Channel ID
        'Default Notifications', // Channel name
        channelDescription: 'This channel is used for default notifications.',
        importance: Importance.max,
        priority: Priority.high,
      );
      const iosDetails = DarwinNotificationDetails();
      const platformDetails =
          NotificationDetails(android: androidDetails, iOS: iosDetails);
      final notifBody = jsonDecode(notification.body!);
      // Show notification
      _localNotif.show(
        notification.hashCode,
        notification.title,
        'aaaa',
        platformDetails,
      );
      if (_notificationStreamController.hasListener) {
        _notificationStreamController.add(message);
      }
      // // Save notification to secure storage
      // await _saveNotificationToStorage(notification, notifBody);
    }
  }

  Future<void> _saveNotificationToStorage(
      RemoteNotification notification, Map<String, dynamic> data) async {
    final timestamp = DateTime.now().toIso8601String();
    final notificationData = {
      'title': notification.title,
      'body': notification.body,
      'data': data,
      'timestamp': timestamp,
    };

    // Save notification as a JSON string
    final key = 'notification_${notification.hashCode}';
    await _secureStorage.save(key: key, value: jsonEncode(notificationData));
  }

  void _handleNotificationTap(RemoteMessage message) {
    logger.i('Notification tapped: ${message.data}');
    // Handle notification tap (e.g., navigate to a specific page)
    debugPrint('Notification tapped: ${message.data}');
  }

  void _onNotificationTap(NotificationResponse response) {
    logger.i('Local notification tapped: ${response.payload}');
    logger.i('Notification tapped: ${response}');
    // Handle local notification tap
    debugPrint('Local notification tapped: ${response.payload}');
  }

  Future<void> deleteYesterdayNotifications() async {
    final allKeys = await _secureStorage.getAllKeys();

    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));

    for (final key in allKeys) {
      if (key.startsWith('notification_')) {
        final jsonString = await _secureStorage.load(key: key);
        if (jsonString != null) {
          try {
            final data = jsonDecode(jsonString);
            final timestampStr = data['timestamp'];
            final timestamp = DateTime.tryParse(timestampStr);

            if (timestamp != null && timestamp.isBefore(yesterday)) {
              await _secureStorage.delete(key: key);
              logger.i('Deleted old notification: $key');
            }
          } catch (e) {
            logger.e('Error parsing/deleting notification [$key]: $e');
          }
        }
      }
    }
  }

  Future<String?> getFcmToken() async {
    return await _messaging.getToken();
  }

  Future<void> clearAllNotifications() async {
    await _localNotif.cancelAll();
  }
}
