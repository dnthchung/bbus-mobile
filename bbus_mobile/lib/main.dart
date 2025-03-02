import 'package:bbus_mobile/config/routes/app_route_conf.dart';
import 'package:bbus_mobile/config/routes/routes.dart';
import 'package:bbus_mobile/config/theme/theme.dart';
import 'package:bbus_mobile/core/network/firebase_api.dart';
import 'package:bbus_mobile/features/authentication/presentation/cubit/auth_cubit.dart';
import 'package:bbus_mobile/features/parent/presentation/pages/parent_home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'config/injector/injector.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseApi().initNotification();
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
        BlocProvider(
            create: (context) => sl<AuthCubit>()..checkLoggedInStatus())
      ],
      child: BlocListener<AuthCubit, AuthState>(
        listenWhen: (_, current) => current is AuthLoggedInStatusSuccess,
        listener: (context, state) => {
          if (state is AuthLoggedInStatusSuccess)
            {router.goNamed(RouteNames.home)}
        },
        child: MaterialApp.router(
          theme: TAppTheme.lightTheme,
          routerConfig: router,
        ),
      ),
    );
  }
}
