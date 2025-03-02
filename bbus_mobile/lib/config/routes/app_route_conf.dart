import 'package:bbus_mobile/features/authentication/presentation/pages/login_page.dart';
import 'package:bbus_mobile/features/children_list/presentation/pages/children_list_page.dart';
import 'package:bbus_mobile/features/parent/presentation/pages/parent_home_page.dart';
import 'package:bbus_mobile/features/parent/presentation/pages/profile.dart';
import 'package:go_router/go_router.dart';
import 'routes.dart';

class AppRouteConf {
  GoRouter get router => _router;

  late final _router = GoRouter(
    // initialLocation: RoutePaths.login,
    initialLocation: RoutePaths.children,
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return ParentHomePage(child: child);
        },
        routes: [
          GoRoute(
            path: RoutePaths.children,
            name: RouteNames.children,
            builder: (_, __) => const ChildrenListPage(),
          ),
          GoRoute(
            path: RoutePaths.profile,
            name: RouteNames.profile,
            builder: (_, __) => const ProfilePage(),
          ),
        ],
      ),
      GoRoute(
        path: RoutePaths.login,
        name: RouteNames.login,
        builder: (_, __) => const LoginPage(),
      ),
    ],
  );
}
