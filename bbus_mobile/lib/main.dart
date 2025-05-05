import 'dart:convert';

import 'package:bbus_mobile/common/cubit/current_user/current_user_cubit.dart';
import 'package:bbus_mobile/common/entities/local_notification_model.dart';
import 'package:bbus_mobile/common/notifications/cubit/notification_cubit.dart';
import 'package:bbus_mobile/common/notifications/notification_service.dart';
import 'package:bbus_mobile/config/routes/app_route_conf.dart';
import 'package:bbus_mobile/config/routes/routes.dart';
import 'package:bbus_mobile/config/theme/theme.dart';
import 'package:bbus_mobile/core/cache/secure_local_storage.dart';
import 'package:bbus_mobile/core/utils/logger.dart';
import 'package:bbus_mobile/features/authentication/presentation/cubit/auth_cubit.dart';
import 'package:bbus_mobile/features/authentication/presentation/cubit/forgot_password/forgot_password_cubit.dart';
import 'package:bbus_mobile/features/change_password/cubit/change_password_cubit.dart';
import 'package:bbus_mobile/features/driver/student_list/cubit/student_list_cubit.dart';
import 'package:bbus_mobile/features/map/cubit/checkpoint/checkpoint_list_cubit.dart';
import 'package:bbus_mobile/features/parent/presentation/cubit/children_list/children_list_cubit.dart';
// import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import 'config/injector/injector.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  Hive.registerAdapter(LocalNotificationModelAdapter());
  initializeDependencies();
  FirebaseMessaging.onBackgroundMessage(_handleBackgroundNotification);
  runApp(const MyApp());
}

@pragma('vm:entry-point')
Future<void> _handleBackgroundNotification(RemoteMessage message) async {
  await Firebase.initializeApp();
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(LocalNotificationModelAdapter().typeId)) {
    Hive.registerAdapter(LocalNotificationModelAdapter());
  }
  logger.i('Background message received: ${message}');
  final notification = message.notification;
  final storage = SecureLocalStorage(const FlutterSecureStorage());
  final userId = await storage.load(key: 'userId');
  if (notification != null && userId.isNotEmpty) {
    final uuid = Uuid();
    final key = uuid.v4();
    final localNotif = LocalNotificationModel(
        title: notification.title ?? '',
        body: notification.body!,
        timestamp: DateTime.now(),
        isRead: false,
        key: key);
    final boxName = 'notificationBox_$userId';
    final notificationBox = Hive.isBoxOpen(boxName)
        ? Hive.box(boxName)
        : await Hive.openBox(boxName);
    try {
      await notificationBox.put(key, localNotif);
      logger.i('Notification saved: $key');
    } catch (e) {
      logger.e('Error saving notification: $e');
    }
  }
  // var notifBody = jsonDecode(notification!.body!);
  // final format = DateFormat("EEE MMM dd HH:mm:ss 'ICT' yyyy");
  // DateTime time = format.parse(notifBody['time']);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final router = AppRouteConf().router;
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<CurrentUserCubit>()),
        BlocProvider(
          create: (context) => sl<AuthCubit>()..checkLoggedInStatus(),
          // create: (context) => sl<AuthCubit>(),
        ),
        BlocProvider(create: (_) => sl<NotificationCubit>()),
        BlocProvider(create: (_) => sl<ForgotPasswordCubit>()),
        BlocProvider(create: (_) => sl<ChildrenListCubit>()),
        BlocProvider(create: (_) => sl<StudentListCubit>()),
        BlocProvider(create: (_) => sl<CheckpointListCubit>()),
        BlocProvider(create: (_) => sl<ChangePasswordCubit>())
      ],
      child: BlocListener<AuthCubit, AuthState>(
        listenWhen: (_, current) => current is AuthLoggedInStatusSuccess,
        listener: (context, state) async {
          if (state is AuthLoggedInStatusSuccess) {
            if (state.data.role?.toLowerCase() == 'parent') {
              await sl<NotificationService>()
                  .init(context.read<NotificationCubit>());
              final fcmToken = await sl<NotificationService>().getFcmToken();
              logger.i('FCM Token: $fcmToken');
              router.goNamed(RouteNames.parentChildren);
            } else if (state.data.role?.toLowerCase() == 'driver') {
              router.goNamed(RouteNames.driverSchedule);
            } else {
              router.goNamed(RouteNames.driverStudent);
            }
          }
          if (state is AuthLoggedInStatusFailure) {
            router.goNamed(RouteNames.login);
          }
        },
        child: MaterialApp.router(
          theme: TAppTheme.lightTheme,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('vi', 'VN'), // Vietnamese
          ],
          locale: Locale('vi', 'VN'),
          routerConfig: router,
        ),
      ),
    );
  }
}
