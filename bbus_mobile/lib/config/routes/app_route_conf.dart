import 'package:bbus_mobile/features/authentication/presentation/pages/login_page.dart';
import 'package:bbus_mobile/features/parent/presentation/pages/parent_home_page.dart';
import 'package:go_router/go_router.dart';
import 'routes.dart';

class AppRouteConf {
  GoRouter get router => _router;

  late final _router = GoRouter(
    initialLocation: RoutePaths.login,
    routes: [
      GoRoute(
        path: RoutePaths.home,
        name: RouteNames.home,
        builder: (_, __) => const ParentHomePage(),
      ),
      GoRoute(
        path: RoutePaths.login,
        name: RouteNames.login,
        builder: (_, __) => const LoginPage(),
      ),
    ],
  );
}