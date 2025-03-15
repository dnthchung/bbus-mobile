import 'package:bbus_mobile/common/widgets/navigation_drawer_widget.dart';
import 'package:bbus_mobile/config/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

String getAppBarTitle(String currentRoute) {
  Map<String, String> routeTitles = {
    RoutePaths.driverStudent: "List Student",
    RoutePaths.driverProfile: "My Profile",
  };
  return routeTitles[currentRoute] ?? "BBUS";
}

final List<(int, IconData, String, String, String)> menuItems = [
  (
    1,
    Icons.people_rounded,
    "List student",
    RoutePaths.driverStudent,
    RouteNames.driverStudent
  ),
  (
    2,
    Icons.person_pin_rounded,
    "Profile",
    RoutePaths.driverProfile,
    RouteNames.driverProfile
  ),
  (
    3,
    Icons.mail,
    "School Contact",
    RoutePaths.driverContact,
    RouteNames.driverContact
  ),
  (
    4,
    Icons.logout,
    "Logout",
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
