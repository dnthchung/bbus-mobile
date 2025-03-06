import 'package:bbus_mobile/features/authentication/presentation/pages/login_page.dart';
import 'package:bbus_mobile/features/child_feature.dart/child_feature_layout.dart';
import 'package:bbus_mobile/features/children_list/presentation/pages/children_list_page.dart';
import 'package:bbus_mobile/features/parent/presentation/pages/parent_home_page.dart';
import 'package:bbus_mobile/features/profile/profile_page.dart';
import 'package:go_router/go_router.dart';
import 'routes.dart';

class AppRouteConf {
  GoRouter get router => _router;

  late final _router = GoRouter(
    // initialLocation: RoutePaths.login,
    initialLocation: RoutePaths.parentChildren,
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return ParentHomePage(child: child);
        },
        routes: [
          GoRoute(
            path: RoutePaths.parentChildren,
            name: RouteNames.parentChildren,
            builder: (_, __) => const ChildrenListPage(),
          ),
          GoRoute(
            path: RoutePaths.parentProfile,
            name: RouteNames.parentProfile,
            builder: (_, __) => const ProfilePage(),
          ),
        ],
      ),
      GoRoute(
        path: '${RoutePaths.childFeature}/:name',
        name: RouteNames.childFeature,
        builder: (context, state) {
          final name = state.pathParameters['name']!;
          return ChildFeatureLayout(childName: Uri.decodeComponent(name));
        },
      ),
      GoRoute(
        path: RoutePaths.login,
        name: RouteNames.login,
        builder: (_, __) => const LoginPage(),
      ),
    ],
  );
}
