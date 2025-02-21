import 'package:bbus_mobile/config/routes/app_route_conf.dart';
import 'package:bbus_mobile/config/routes/routes.dart';
import 'package:bbus_mobile/config/theme/theme.dart';
import 'package:bbus_mobile/features/authentication/presentation/cubit/auth_cubit.dart';
import 'package:bbus_mobile/features/authentication/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'config/injector/injector.dart';

void main() {
  initializeDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final router = AppRouteConf().router;
    // return MaterialApp(
    //   theme: AppTheme.defaultThemeMode,
    //   home: const LoginPage(),
    // );
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => sl<AuthCubit>()..checkLoggedInStatus())
      ],
      child: BlocListener<AuthCubit, AuthState>(
        listenWhen: (_, current) => current is AuthSucess,
        listener: (context, state) => {
          if (state is AuthSucess) {router.goNamed(RouteNames.home)}
        },
        child: MaterialApp.router(
          theme: AppTheme.defaultThemeMode,
          routerConfig: router,
        ),
      ),
    );
  }
}
