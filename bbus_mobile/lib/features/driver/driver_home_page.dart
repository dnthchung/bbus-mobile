import 'package:bbus_mobile/common/entities/user.dart';
import 'package:bbus_mobile/common/widgets/navigation_drawer_widget.dart';
import 'package:bbus_mobile/config/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

String getAppBarTitle(String currentRoute) {
  Map<String, String> routeTitles = {
    RoutePaths.driverStudent: "Danh sách học sinh",
    RoutePaths.driverProfile: "Thông tin trường",
    RoutePaths.driverSchedule: "Lịch xe",
  };
  return routeTitles[currentRoute] ?? "BBUS";
}

final List<(int, IconData, String, String, String)> menuItems = [
  (
    1,
    Icons.people_rounded,
    "Danh sách học sinh",
    RoutePaths.driverStudent,
    RouteNames.driverStudent
  ),
  (
    2,
    Icons.calendar_today,
    "Lịch xe",
    RoutePaths.driverSchedule,
    RouteNames.driverSchedule
  ),
  (
    3,
    Icons.mail,
    "Liên hệ trường",
    RoutePaths.driverContact,
    RouteNames.driverContact
  ),
  (
    4,
    Icons.logout,
    "Đăng xuất",
    '/logout',
    'logout',
  ),
];

class DriverHomePage extends StatelessWidget {
  final Widget child;
  DriverHomePage({super.key, required this.child});
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final String currentRoute =
        GoRouter.of(context).routeInformationProvider.value.uri.path;
    final String appBarTitle = getAppBarTitle(currentRoute);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(appBarTitle),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
      drawer: NavigationDrawerWidget(
        menuItems: menuItems,
        currentRoute: currentRoute,
      ),
      body: child,
    );
  }
}
