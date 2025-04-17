import 'package:bbus_mobile/common/cubit/current_user/current_user_cubit.dart';
import 'package:bbus_mobile/common/entities/user.dart';
import 'package:bbus_mobile/config/routes/routes.dart';
import 'package:bbus_mobile/config/theme/colors.dart';
import 'package:bbus_mobile/features/authentication/presentation/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class NavigationDrawerWidget extends StatelessWidget {
  final String currentRoute;
  final List menuItems;
  const NavigationDrawerWidget({
    super.key,
    required this.currentRoute,
    required this.menuItems,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            BlocBuilder<CurrentUserCubit, CurrentUserState>(
              builder: (context, state) {
                if (state is CurrentUserLoggedIn) {
                  return DrawerHeader(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipOval(
                          child: Image.network(
                            state.user.avatar ?? '',
                            height: 70,
                            width: 70,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Image(
                                image: AssetImage(
                                    'assets/images/default_avatar.png'),
                                height: 70,
                                width: 70,
                                fit: BoxFit.cover,
                              );
                            },
                          ),
                        ),
                        SizedBox(width: 12), // Space between image and text
                        Text(
                          state.user.name ?? 'Unknown User',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          state.user.email ?? "john.doe@example.com",
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  );
                }
                return DrawerHeader(child: SizedBox());
              },
            ),
            ...menuItems.map(
              (item) => MenuItem(
                id: item.$1,
                icon: item.$2,
                title: item.$3,
                isSelected: item.$4 == currentRoute ? true : false,
                onTap: () {
                  Scaffold.of(context).closeDrawer();
                  if (item.$5 != 'logout') {
                    if (item.$5 != currentRoute) {
                      context.goNamed(item.$5);
                    }
                  } else {
                    context.read<AuthCubit>().logout();
                    context.goNamed(RouteNames.login);
                  }
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
