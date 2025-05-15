import 'package:flutter/material.dart';

class AppColors {
  // Primary colors (Orange tones from logo)
  static const Color primary = Color(0xFFd6620a); // Warm Orange
  static const Color primaryDark = Color(0xFFb44c00); // Darker Orange
  static const Color primaryLight = Color(0xFFf57c00); // Lighter Orange

  // Secondary colors (Brown tones for complement)
  static const Color secondary = Color(0xFF5D4037); // Brown
  static const Color secondaryDark = Color(0xFF3E2723); // Dark Brown
  static const Color secondaryLight = Color(0xFF8D6E63); // Light Brown

  // Accent colors (Soft cream and friendly tones)
  static const Color accent = Color(0xFFFFE0B2); // Light Orange/Cream
  static const Color accentDark = Color(0xFFFFCC80); // Medium Cream
  static const Color accentLight = Color(0xFFFFF3E0); // Lightest Cream

  // Background colors
  static const Color background = Color(0xFFFFFBF5); // Warm Light Background
  static const Color surface = Color(0xFFFFFFFF); // White

  // Text colors
  static const Color textPrimary = Color(0xFF3E2723); // Dark Brown
  static const Color textSecondary = Color(0xFF6D4C41); // Medium Brown
  static const Color textOnPrimary = Color(0xFFFFFFFF); // White
  static const Color textOnSecondary = Color(0xFFFFFFFF); // White

  // Error color
  static const Color error = Color(0xFFD32F2F); // Red

  // Other colors
  static const Color divider = Color(0xFFD7CCC8); // Light Brown Divider
  static const Color hint = Color(0xFFA1887F); // Soft Brown Hint
  static const Color disabled = Color(0xFFBCAAA4); // Muted Brown

  static const defaultTextStyle = TextStyle(
    fontSize: 18,
    color: Colors.white,
    fontWeight: FontWeight.w700,
    fontFamily: "Cairo",
  );

  // Example usage in a ThemeData
  static ThemeData getThemeData() {
    return ThemeData(
      primaryColor: primary,
      primaryColorDark: primaryDark,
      primaryColorLight: primaryLight,
      scaffoldBackgroundColor: background,
      dividerColor: divider,
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: textPrimary),
        bodyLarge: TextStyle(color: textPrimary),
        bodyMedium: TextStyle(color: textSecondary),
      ),
      appBarTheme: AppBarTheme(
        color: primary,
        iconTheme: const IconThemeData(color: textOnPrimary),
        toolbarTextStyle: const TextTheme(
          titleLarge: TextStyle(color: textOnPrimary, fontSize: 20),
        ).bodyMedium,
        titleTextStyle: const TextTheme(
          titleLarge: TextStyle(color: textOnPrimary, fontSize: 20),
        ).titleLarge,
      ),
      buttonTheme: const ButtonThemeData(
        buttonColor: primary,
        textTheme: ButtonTextTheme.primary,
      ),
      colorScheme: ColorScheme.fromSwatch().copyWith(
        secondary: accent,
      ),
    );
  }
}