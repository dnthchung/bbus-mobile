import 'package:bbus_mobile/features/authentication/presentation/pages/login_page.dart';
import 'package:bbus_mobile/features/change_password/change_password_page.dart';
import 'package:bbus_mobile/features/parent/presentation/pages/child_feature_layout.dart';
import 'package:bbus_mobile/features/parent/presentation/pages/children_list_page.dart';
import 'package:bbus_mobile/features/contact/school_contact_page.dart';
import 'package:bbus_mobile/features/driver/driver_home_page.dart';
import 'package:bbus_mobile/features/driver/student_list/student_list_page.dart';
import 'package:bbus_mobile/features/map/bus_tracking_map.dart';
import 'package:bbus_mobile/features/map/edit_location_map.dart';
import 'package:bbus_mobile/features/map/map_page.dart';
import 'package:bbus_mobile/features/notification/notification_page.dart';
import 'package:bbus_mobile/features/notification/notification_setting_page.dart';
import 'package:bbus_mobile/features/parent/presentation/pages/parent_home_page.dart';
import 'package:bbus_mobile/features/profile/profile_page.dart';
import 'package:bbus_mobile/features/request/requests_page.dart';
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
          GoRoute(
            path: RoutePaths.parentChangePassword,
            name: RouteNames.parentChangePassword,
            builder: (_, __) => ChangePasswordPage(),
          ),
          GoRoute(
            path: RoutePaths.parentContact,
            name: RouteNames.parentContact,
            builder: (_, __) => const SchoolContactPage(),
          ),
          GoRoute(
            path: RoutePaths.parentSetting,
            name: RouteNames.parentSetting,
            builder: (_, __) => const NotificationSettingPage(),
          ),
          GoRoute(
            path: RoutePaths.parentRequest,
            name: RouteNames.parentRequest,
            builder: (_, __) => RequestsPage(),
          ),
        ],
      ),
      ShellRoute(
        builder: (context, state, child) {
          return DriverHomePage(child: child);
        },
        routes: [
          GoRoute(
            path: RoutePaths.driverStudent,
            name: RouteNames.driverStudent,
            builder: (_, __) => const StudentListPage(),
          ),
          GoRoute(
            path: RoutePaths.driverProfile,
            name: RouteNames.driverProfile,
            builder: (_, __) => const ProfilePage(),
          ),
          GoRoute(
            path: RoutePaths.driverContact,
            name: RouteNames.driverContact,
            builder: (_, __) => const SchoolContactPage(),
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
        path: RoutePaths.parentNotification,
        name: RouteNames.parentNotification,
        builder: (_, __) => const NotificationPage(),
      ),
      GoRoute(
        path: RoutePaths.parentEditLocation,
        name: RouteNames.parentEditLocation,
        builder: (_, __) => const EditLocationMap(),
      ),
      GoRoute(
        path: RoutePaths.parentBusMap,
        name: RouteNames.parentBusMap,
        builder: (_, __) => const BusTrackingMap(),
      ),
      GoRoute(
        path: RoutePaths.login,
        name: RouteNames.login,
        builder: (_, __) => const LoginPage(),
      ),
    ],
  );
}
