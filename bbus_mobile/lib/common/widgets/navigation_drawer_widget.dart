import 'package:bbus_mobile/config/routes/routes.dart';
import 'package:bbus_mobile/config/theme/colors.dart';
import 'package:bbus_mobile/features/authentication/presentation/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

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
    Icons.logout,
    "Logout",
    '/logout',
    'logout',
  ),
];

class NavigationDrawerWidget extends StatelessWidget {
  final String currentRoute;
  const NavigationDrawerWidget({super.key, required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 35, // Adjust size
                    backgroundImage:
                        AssetImage("assets/images/default_avatar.png"),
                  ),
                  SizedBox(width: 12), // Space between image and text
                  Text(
                    "John Doe",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "john.doe@example.com",
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
            ...menuItems.map(
              (item) => MenuItem(
                id: item.$1,
                icon: item.$2,
                title: item.$3,
                isSelected: item.$4 == currentRoute ? true : false,
                onTap: () {
                  if (item.$5 != 'logout') {
                    context.goNamed(item.$5);
                  } else {
                    context.read<AuthCubit>().logout();
                  }
                  Scaffold.of(context).closeDrawer();
                  context.goNamed(RouteNames.login);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget MenuItem({
    required int id,
    required IconData icon,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Material(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        splashColor: TColors.primary.withAlpha(51),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          decoration: BoxDecoration(
            color: isSelected ? TColors.darkPrimary : Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 28.0,
                color: isSelected ? Colors.white : TColors.primary,
              ),
              SizedBox(
                width: 15.0,
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? TColors.textWhite : TColors.textPrimary,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
