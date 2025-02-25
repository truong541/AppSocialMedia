import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF6200EE);
  static const Color secondary = Color(0xFF03DAC6);

  static Color background(Brightness brightness) =>
      brightness == Brightness.light
          ? const Color(0xFFFFFFFF)
          : const Color(0xFF121212);

  static Color surface(Brightness brightness) => brightness == Brightness.light
      ? const Color(0xFFF5F5F5)
      : const Color(0xFF1E1E1E);

  static Color onPrimary(Brightness brightness) =>
      brightness == Brightness.light
          ? const Color(0xFFFFFFFF)
          : const Color(0xFFFFFFFF);

  static Color onSecondary(Brightness brightness) =>
      brightness == Brightness.light
          ? const Color(0xFFFFFFFF)
          : const Color(0xFF121212);

  static Color onBackground(Brightness brightness) =>
      brightness == Brightness.light
          ? const Color(0xFF000000)
          : const Color(0xFFFFFFFF);

  static Color onSurface(Brightness brightness) =>
      brightness == Brightness.light
          ? const Color(0xFF000000)
          : const Color(0xFFFFFFFF);

  static Color surfaceContainer(Brightness brightness) =>
      brightness == Brightness.light
          ? const Color(0xFFFFFFFF)
          : const Color(0xFF999999);

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: primary,
      scaffoldBackgroundColor: background(Brightness.light),
      colorScheme: ColorScheme.light(
        primary: primary,
        secondary: secondary,
        surfaceContainer: surfaceContainer(Brightness.light),
        // background: background(Brightness.light),
        surface: surface(Brightness.light),
        onPrimary: onPrimary(Brightness.light),
        onSecondary: onSecondary(Brightness.light),
        // onBackground: onBackground(Brightness.light),
        onSurface: onSurface(Brightness.light),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: primary,
      scaffoldBackgroundColor: background(Brightness.dark),
      colorScheme: ColorScheme.dark(
        primary: primary,
        secondary: secondary,
        surfaceContainer: surfaceContainer(Brightness.dark),
        // background: background(Brightness.dark),
        surface: surface(Brightness.dark),
        onPrimary: onPrimary(Brightness.dark),
        onSecondary: onSecondary(Brightness.dark),
        // onBackground: onBackground(Brightness.dark),
        onSurface: onSurface(Brightness.dark),
      ),
    );
  }
}
