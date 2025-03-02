import 'package:bbus_mobile/common/widgets/navigation_drawer_widget.dart';
import 'package:bbus_mobile/config/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

String getAppBarTitle(String currentRoute) {
  Map<String, String> routeTitles = {
    RoutePaths.home: "Home",
    RoutePaths.children: "My Children",
    RoutePaths.profile: "My Profile",
  };
  return routeTitles[currentRoute] ?? "BBUS";
}

class ParentHomePage extends StatefulWidget {
  final Widget child;
  const ParentHomePage({super.key, required this.child});
  @override
  State<ParentHomePage> createState() => _ParentHomePageState();
}

class _ParentHomePageState extends State<ParentHomePage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    final String currentRoute =
        GoRouter.of(context).routeInformationProvider.value.uri.path;
    final String appBarTitle = getAppBarTitle(currentRoute);
    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: Text(appBarTitle),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            _key.currentState?.openDrawer();
          },
        ),
      ),
      drawer: NavigationDrawerWidget(
        currentRoute: currentRoute,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Hello, World'),
            ElevatedButton(
              onPressed: () {},
              child: Text('Elevated Button'),
            ),
            TextButton(
              onPressed: () {},
              child: Text('Text Button'),
            ),
            OutlinedButton(
              onPressed: () {},
              child: Text('Outline Button'),
            ),
            Switch.adaptive(value: false, onChanged: (v) {})
          ],
        ),
      ),
    );
  }
}
