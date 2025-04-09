import 'package:bbus_mobile/config/theme/colors.dart';
import 'package:flutter/material.dart';

class TAppTheme {
  TAppTheme._();
  static ThemeData lightTheme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        brightness: Brightness.light,
        seedColor: TColors.primary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: TColors.primary,
        iconTheme: IconThemeData(
          color: TColors.textWhite,
        ),
        elevation: 0,
        titleTextStyle: TextStyle(
          color: TColors.textWhite,
          fontSize: 22.0,
          fontWeight: FontWeight.w600,
        ),
        centerTitle: true,
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
        backgroundColor: TColors.darkPrimary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Rounded corners
        ),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      )));
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.dark,
      seedColor: TColors.primary,
    ),
  );
}
