import 'dart:async';

import 'package:bbus_mobile/common/entities/local_notification_model.dart';
import 'package:bbus_mobile/common/notifications/cubit/notification_cubit.dart';
import 'package:bbus_mobile/config/injector/injector.dart';
import 'package:bbus_mobile/core/cache/secure_local_storage.dart';
import 'package:bbus_mobile/core/utils/logger.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();
  final _format = DateFormat("yyyy-MM-dd HH:mm:ss");
  String? _userId;
  late Box _notificationBox;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotif =
      FlutterLocalNotificationsPlugin();
  final _secureStorage = sl<SecureLocalStorage>();
  NotificationCubit? _notificationCubit;
  final StreamController<dynamic> _notificationStreamController =
      StreamController.broadcast();
  Stream<dynamic> get notificationStream =>
      _notificationStreamController.stream;
  bool _hasListeners = false;
  Future<void> init(NotificationCubit cubit) async {
    // Request notification permissions
    _userId = await _secureStorage.load(key: 'userId');
    logger.i(_userId);
    final boxName = 'notificationBox_$_userId';
    if (!Hive.isBoxOpen(boxName)) {
      _notificationBox = await Hive.openBox(boxName);
    } else {
      _notificationBox = Hive.box(boxName);
    }
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('Permission_Granted');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('Provisional_Permission_Granted');
    } else {
      print('Permission_Denied');
    }
    _notificationCubit = cubit;

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
    if (!_hasListeners) {
      FirebaseMessaging.onMessage.listen(_handleForegroundNotification);
      FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);
      _hasListeners = true;
    }
  }

  void _handleForegroundNotification(message) async {
    try {
      logger.i('Message without notification: ${message}');
      logger.i({
        'title': message.notification?.title,
        'body': message.notification?.body,
        'data': message.data,
      });
      final notification = message.notification;
      if (notification != null) {
        const androidDetails = AndroidNotificationDetails(
          'high_importance_channel', // Channel ID
          'High Importance Notifications', // Channel name
          channelDescription: 'This channel is used for default notifications.',
          importance: Importance.max,
          priority: Priority.high,
        );
        const iosDetails = DarwinNotificationDetails();
        const platformDetails =
            NotificationDetails(android: androidDetails, iOS: iosDetails);
        final uuid = Uuid();
        final key = uuid.v4();
        if (!notification.title.startsWith('Con của bạn')) {
          await _localNotif.show(
            notification.hashCode,
            notification.title,
            notification.body,
            platformDetails,
          );
          final localNotif = LocalNotificationModel(
              title: notification.title ?? '',
              body: notification.body,
              timestamp: DateTime.now(),
              isRead: false,
              key: key);

          await addNotification(localNotif);
        } else {
          var notifBody = jsonDecode(notification.body!);
          DateTime time =
              _format.parse(notifBody['time']).add(Duration(hours: 7));
          final notifBodyText =
              'Con ${notifBody['studentName']} đã ${notifBody['status'] == 'IN_BUS' ? 'lên xe' : notifBody['direction'] == 'PICK_UP' ? 'dến trường' : 'về điểm đón'} lúc ${_format.format(time)}';
          // Show notification
          await _localNotif.show(
            notification.hashCode,
            notification.title,
            notifBodyText,
            platformDetails,
          );
          if (_notificationStreamController.hasListener) {
            logger.i('Notification stream has listener');
            if (notifBody['direction'] == 'PICK_UP' ||
                notifBody['direction'] == 'DROP_OFF') {
              notifBody['time'] = _format.format(time);
              _notificationStreamController.add(notifBody);
            }
          }
          // // Save notification to secure storage
          final localNotif = LocalNotificationModel(
              title: notification.title ?? '',
              body: notifBodyText,
              timestamp: time,
              isRead: false,
              key: key);
          logger.i('call add');
          await addNotification(localNotif);
        }
      }
    } catch (e) {
      logger.e(e);
    }
  }
  // Future<void> _saveNotificationToStorage(LocalNotificationModel notif) async {
  //   final boxName = 'notificationBox_$_userId';
  //   final key = 'notification_${notif.timestamp.toIso8601String()}';
  //   if (!Hive.isBoxOpen(boxName)) {
  //     await Hive.openBox(boxName);
  //   }

  //   final box = Hive.box(boxName);
  //   try {
  //     await box.put(key, notif);
  //     return;
  //   } catch (_) {
  //     rethrow;
  //   } finally {
  //     await box.close();
  //   }
  // }

  Future<List<LocalNotificationModel>> loadUserNotifications() async {
    final boxName = 'notificationBox_$_userId';
    if (!Hive.isBoxOpen(boxName)) {
      await Hive.openBox(boxName);
    }

    final box = Hive.box(boxName);
    final notifs = box.values.whereType<LocalNotificationModel>().toList();
    notifs.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return notifs;
  }

  Future<void> addNotification(LocalNotificationModel notif) async {
    try {
      await _notificationBox.put(notif.key, notif);
      await _notificationCubit?.addNotification(notif);
      logger.i('Notification saved: ${notif.key}');
    } catch (e) {
      logger.e('Error saving notification: $e');
    }
  }

  Future<void> markAllAsRead() async {
    for (int i = 0; i < _notificationBox.length; i++) {
      final item = _notificationBox.getAt(i);
      if (item is LocalNotificationModel && !item.isRead) {
        _notificationBox.putAt(
            i,
            LocalNotificationModel(
                title: item.title,
                body: item.body,
                timestamp: item.timestamp,
                isRead: true,
                key: item.key));
      }
    }
  }

  // Mark a single notification as read
  Future<void> markOneAsRead(LocalNotificationModel notif) async {
    try {
      final updatedNotif = LocalNotificationModel(
          title: notif.title,
          body: notif.body,
          timestamp: notif.timestamp,
          isRead: true,
          key: notif.key);
      await _notificationBox.put(notif.key, updatedNotif);
      logger.i('Notification marked as read: ${notif.key}');
    } catch (e) {
      logger.e('Error marking notification as read: $e');
    }
  }

  Future<void> deleteAllRead() async {
    final unreadKeys = _notificationBox.keys.where((key) {
      final notif = _notificationBox.get(key);
      return notif != null && notif is LocalNotificationModel && notif.isRead;
    }).toList();

    for (var key in unreadKeys) {
      _notificationBox.delete(key);
    }
  }

  Future<void> deleteAll() async {
    await _notificationBox.clear();
  }

  void _handleNotificationTap(RemoteMessage message) async {
    logger.i('Notification tapped: ${message.notification}');
    // await _notificationCubit!.loadNotifications();
  }

  void _onNotificationTap(NotificationResponse response) {
    logger.i('Local notification tapped: ${response.payload}');
    logger.i('Notification tapped: ${response}');
    // Handle local notification tap
    debugPrint('Local notification tapped: ${response.payload}');
  }

  Future<String?> getFcmToken() async {
    return await _messaging.getToken();
  }

  Future<void> clearAllNotifications() async {
    await _localNotif.cancelAll();
  }

  Future<void> closeBox() async {
    final boxName = 'notificationBox_$_userId';
    if (Hive.isBoxOpen(boxName)) {
      await Hive.box(boxName).close();
      logger.i('Notification box closed for user $_userId');
    }
  }
}
