import 'package:bbus_mobile/common/widgets/navigation_drawer_widget.dart';
import 'package:bbus_mobile/config/routes/routes.dart';
import 'package:bbus_mobile/config/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

String getAppBarTitle(String currentRoute) {
  Map<String, String> routeTitles = {
    RoutePaths.parentChildren: "My Children",
    RoutePaths.parentProfile: "My Profile",
    RoutePaths.parentEditLocation: "Edit Location",
    RoutePaths.parentSetting: "Settings",
  };
  return routeTitles[currentRoute] ?? "BBUS";
}

final List<(int, IconData, String, String, String)> menuItems = [
  (
    1,
    Icons.people_rounded,
    "My children",
    RoutePaths.parentChildren,
    RouteNames.parentChildren
  ),
  (
    2,
    Icons.person_pin_rounded,
    "Profile",
    RoutePaths.parentProfile,
    RouteNames.parentProfile
  ),
  (
    3,
    Icons.add_location_alt,
    "Edit Location",
    RoutePaths.parentEditLocation,
    RouteNames.parentEditLocation
  ),
  (
    4,
    Icons.settings,
    "Settings",
    RoutePaths.parentSetting,
    RouteNames.parentSetting
  ),
  (
    5,
    Icons.mail,
    "School Contact",
    RoutePaths.parentContact,
    RouteNames.parentContact
  ),
  (
    6,
    Icons.logout,
    "Logout",
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
      appBar: AppBar(
        title: Text(appBarTitle),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        actions: currentRoute == RoutePaths.parentChildren
            ? [
                Stack(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.notifications),
                      onPressed: () {
                        // Navigate to notifications page
                        context.pushNamed(RouteNames.parentNotification);
                      },
                    ),
                    // if (unreadNotifications > 0)
                    Positioned(
                      right: 11,
                      top: 11,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: TColors.error,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 14,
                          minHeight: 14,
                        ),
                        child: Text(
                          // unreadNotifications.toString(),
                          "0",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ]
            : [],
      ),
      drawer: NavigationDrawerWidget(
        menuItems: menuItems,
        currentRoute: currentRoute,
      ),
      body: child,
    );
  }
}
