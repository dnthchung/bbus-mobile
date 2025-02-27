import 'package:bbus_mobile/core/utils/logger.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> handleBackgroundMessage(RemoteMessage? message) async {
  // print('In handle');
  // print('Title: ${message?.notification?.title}');
  // print('Body: ${message?.notification?.body}');
  // print('Payload: ${message?.data}');
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotification() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    logger.i('Token: $fCMToken');
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }
}
