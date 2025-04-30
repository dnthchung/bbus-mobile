import 'package:bbus_mobile/common/entities/user.dart';
import 'package:bbus_mobile/common/notifications/cubit/notification_cubit.dart';
import 'package:bbus_mobile/common/widgets/navigation_drawer_widget.dart';
import 'package:bbus_mobile/config/injector/injector.dart';
import 'package:bbus_mobile/config/routes/routes.dart';
import 'package:bbus_mobile/config/theme/colors.dart';
import 'package:bbus_mobile/features/parent/presentation/cubit/children_list/children_list_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

Map<String, String> routeTitles = {
  RoutePaths.parentChildren: "Con của tôi",
  RoutePaths.parentProfile: "Hồ sơ",
  RoutePaths.parentEditLocation: "Gửi yêu cầu",
  RoutePaths.parentChangePassword: "Đổi mật khẩu",
  RoutePaths.parentSetting: "Cài đặt",
  RoutePaths.parentRequest: "Các loại đơn",
  RoutePaths.parentContact: "Thông tin liên hệ",
};
String getAppBarTitle(String currentRoute) {
  return routeTitles[currentRoute] ?? "BBUS";
}

final List<(int, IconData, String, String, String)> menuItems = [
  (
    1,
    Icons.people_rounded,
    "Con tôi",
    RoutePaths.parentChildren,
    RouteNames.parentChildren
  ),
  (
    2,
    Icons.person_pin_rounded,
    "Hồ sơ",
    RoutePaths.parentProfile,
    RouteNames.parentProfile
  ),
  (
    3,
    Icons.widgets,
    "Gửi yêu cầu",
    RoutePaths.parentRequest,
    RouteNames.parentRequest
  ),
  // (
  //   4,
  //   Icons.settings,
  //   "Cài đặt",
  //   RoutePaths.parentSetting,
  //   RouteNames.parentSetting
  // ),
  (
    5,
    Icons.mail,
    "Liên hệ nhà trường",
    RoutePaths.parentContact,
    RouteNames.parentContact
  ),
  (
    6,
    Icons.key,
    "Đổi mật khẩu",
    RoutePaths.parentChangePassword,
    RouteNames.parentChangePassword
  ),
  (
    7,
    Icons.logout,
    "Đăng xuất",
    '/logout',
    'logout',
  ),
];

class ParentHomePage extends StatelessWidget {
  final Widget child;
  ParentHomePage({super.key, required this.child});
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final String currentRoute =
        GoRouter.of(context).routeInformationProvider.value.uri.path;
    final String appBarTitle = getAppBarTitle(currentRoute);
    return Scaffold(
      key: _scaffoldKey,
      appBar: routeTitles.containsKey(currentRoute)
          ? AppBar(
              title: Text(appBarTitle),
              leading: IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
              ),
              actions: [
                  BlocBuilder<NotificationCubit, NotificationState>(
                    builder: (context, state) {
                      return Stack(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.notifications),
                            onPressed: () {
                              // Navigate to notifications page
                              context
                                  .read<NotificationCubit>()
                                  .loadNotifications();
                              context.pushNamed(RouteNames.parentNotification);
                            },
                          ),
                          // if (unreadNotifications > 0)
                          if (state.hasUnread)
                            Positioned(
                              right: 11,
                              top: 11,
                              child: Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: TColors.error,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ])
          : null,
      drawer: NavigationDrawerWidget(
        menuItems: menuItems,
        currentRoute: currentRoute,
      ),
      body: child,
    );
  }
}
