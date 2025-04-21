import 'package:bbus_mobile/common/cubit/current_user/current_user_cubit.dart';
import 'package:bbus_mobile/common/notifications/notification_service.dart';
import 'package:bbus_mobile/config/routes/app_route_conf.dart';
import 'package:bbus_mobile/config/routes/routes.dart';
import 'package:bbus_mobile/config/theme/theme.dart';
import 'package:bbus_mobile/core/utils/logger.dart';
import 'package:bbus_mobile/features/authentication/data/datasources/auth_remote_datasource.dart';
import 'package:bbus_mobile/features/authentication/presentation/cubit/auth_cubit.dart';
import 'package:bbus_mobile/features/authentication/presentation/cubit/forgot_password/forgot_password_cubit.dart';
import 'package:bbus_mobile/features/change_password/cubit/change_password_cubit.dart';
import 'package:bbus_mobile/features/driver/student_list/cubit/student_list_cubit.dart';
import 'package:bbus_mobile/features/map/cubit/checkpoint/checkpoint_list_cubit.dart';
import 'package:bbus_mobile/features/parent/presentation/cubit/children_list/children_list_cubit.dart';
import 'package:bbus_mobile/features/parent/presentation/cubit/request_list/request_list_cubit.dart';
// import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'config/injector/injector.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  initializeDependencies();
  runApp(const MyApp());
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
              await sl<NotificationService>().init();
              final fcmToken = await sl<NotificationService>().getFcmToken();
              logger.i('FCM Token: $fcmToken');
              await sl<AuthRemoteDatasource>().updatDeviceToken(fcmToken!);
              router.goNamed(RouteNames.parentChildren);
            } else {
              router.goNamed(RouteNames.driverStudent);
            }
          }
        },
        child: MaterialApp.router(
          theme: TAppTheme.lightTheme,
          routerConfig: router,
        ),
      ),
    );
  }
}
