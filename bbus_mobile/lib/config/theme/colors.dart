import 'package:flutter/material.dart';

class TColors {
  TColors._();
  static const Color primary = Color(0xFFFF5722);
  static const Color lightPrimary = Color(0xFFFFCCBC);
  static const Color darkPrimary = Color(0xFFE64A19);
  static const Color secondary = Color(0xFF4CAE4F);
  static const Color lightSecondary = Color(0xFF8BC34B);
  static const Color darkSecondary = Color(0xFF137032);
  static const Color accent = Color(0xFFFF9800);
  static const Color error = Color.fromARGB(244, 212, 24, 24);
  static const Color fillColor = Colors.white;
  static const Color borderColor = Color(0xFF757575);
  static const Color secondaryBackground = Color(0xFF757575);
  static const Color inactive = Color(0xFF757575);
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [
      Color(0xFFFFCCBC), // lightPrimary
      Color(0xFFFF5722), // primary
      Color(0xFFE64A19), // darkPrimary
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [
      Color(
          0xFF81C784), // lightSecondary (lighter shade of the secondary color)
      Color(0xFF4CAE4F), // secondary
      Color(0xFF388E3C), // darkSecondary (darker shade of the secondary color)
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  // Text Colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textWhite = Colors.white;
  static const Color textSecondary = Color(0xFF757575);
}
