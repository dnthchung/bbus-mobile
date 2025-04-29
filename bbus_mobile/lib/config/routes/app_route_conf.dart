import 'package:bbus_mobile/common/cubit/current_user/current_user_cubit.dart';
import 'package:bbus_mobile/common/entities/child.dart';
import 'package:bbus_mobile/common/entities/user.dart';
import 'package:bbus_mobile/config/injector/injector.dart';
import 'package:bbus_mobile/core/utils/logger.dart';
import 'package:bbus_mobile/features/authentication/presentation/pages/forgot_password_page.dart';
import 'package:bbus_mobile/features/authentication/presentation/pages/login_page.dart';
import 'package:bbus_mobile/features/authentication/presentation/pages/otp_verify_page.dart';
import 'package:bbus_mobile/features/authentication/presentation/pages/reset_password_page.dart';
import 'package:bbus_mobile/features/change_password/change_password_page.dart';
import 'package:bbus_mobile/features/map/driver_map.dart';
import 'package:bbus_mobile/features/notification/cubit/notification_cubit.dart';
import 'package:bbus_mobile/features/parent/presentation/cubit/request_list/request_list_cubit.dart';
import 'package:bbus_mobile/features/parent/presentation/pages/absent_request_page.dart';
import 'package:bbus_mobile/features/parent/presentation/pages/add_location_page.dart';
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
import 'package:bbus_mobile/features/parent/presentation/pages/edit_child_page.dart';
import 'package:bbus_mobile/features/parent/presentation/pages/parent_home_page.dart';
import 'package:bbus_mobile/features/profile/profile_page.dart';
import 'package:bbus_mobile/features/parent/presentation/pages/requests_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'routes.dart';

class AppRouteConf {
  GoRouter get router => _router;
  final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>();
  late final _router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    // initialLocation: RoutePaths.login,
    initialLocation: RoutePaths.parentRequest,
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => sl<NotificationCubit>(),
              ),
              BlocProvider(
                create: (context) => sl<RequestListCubit>(),
              ),
            ],
            child: ParentHomePage(
              child: child,
            ),
          );
        },
        routes: [
          GoRoute(
            path: RoutePaths.parentChildren,
            name: RouteNames.parentChildren,
            builder: (_, __) => const ChildrenListPage(),
            routes: [
              GoRoute(
                path: RoutePaths.parentEditChild,
                name: RouteNames.parentEditChild,
                builder: (context, state) {
                  final data = state.extra as ChildEntity;
                  return EditChildPage(
                    child: data,
                  );
                },
              ),
            ],
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
              builder: (context, __) => BlocProvider.value(
                    value: context.read<RequestListCubit>()..getRequestList(),
                    child: RequestsPage(),
                  ),
              routes: [
                GoRoute(
                  path: RoutePaths.parentAbsentRequest,
                  name: RouteNames.parentAbsentRequest,
                  builder: (_, __) => AbsentRequestPage(),
                ),
                GoRoute(
                  path: RoutePaths.parentOtherRequest,
                  name: RouteNames.parentOtherRequest,
                  builder: (_, __) => AddLocationPage(),
                ),
              ]),
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
            path: RoutePaths.driverContact,
            name: RouteNames.driverContact,
            builder: (_, __) => const SchoolContactPage(),
          ),
        ],
      ),
      GoRoute(
        path: '${RoutePaths.childFeature}/:id',
        name: RouteNames.childFeature,
        builder: (context, state) {
          final id = state.pathParameters['id'];
          logger.i(id);
          final data = state.extra as ChildEntity;
          return ChildFeatureLayout(
            child: data,
          );
        },
      ),
      GoRoute(
        path: RoutePaths.parentNotification,
        name: RouteNames.parentNotification,
        builder: (_, __) => const NotificationPage(),
      ),
      GoRoute(
        path: '${RoutePaths.parentEditLocation}/:actionType',
        name: RouteNames.parentEditLocation,
        builder: (_, state) {
          final actionType = state.pathParameters['actionType'];
          return EditLocationMap(
            actionType: actionType!,
          );
        },
      ),
      // GoRoute(
      //   path: RoutePaths.parentBusMap,
      //   name: RouteNames.parentBusMap,
      //   builder: (_, __) => const BusTrackingMap(),
      // ),
      GoRoute(
        path: '${RoutePaths.driverBusMap}/:routeId',
        name: RouteNames.driverBusMap,
        builder: (_, state) {
          String? routeId = state.pathParameters['routeId'];
          return DriverMap(
            routeId: routeId!,
          );
        },
      ),
      GoRoute(
        path: RoutePaths.forgotPassword,
        name: RouteNames.forgotPassword,
        builder: (_, __) => ForgotPasswordPage(),
      ),
      GoRoute(
        path: '${RoutePaths.otpVerification}/:phone',
        name: RouteNames.otpVerification,
        builder: (_, state) {
          String? phoneNumber = state.pathParameters['phone'];
          return OtpVerifyPage(
            phoneNumber: phoneNumber!,
          );
        },
      ),
      GoRoute(
        path: '${RoutePaths.resetPassword}/:sessionId',
        name: RouteNames.resetPassword,
        builder: (_, state) {
          String? sessionId = state.pathParameters['sessionId'];
          return ResetPasswordPage(sessionId: sessionId!);
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
