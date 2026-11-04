// lib/core/theme/app_theme.dart
import 'package:flutter/material.dart';

/// PJ Masks brand colour system extracted from the original APK resources.arsc
class AppColors {
  AppColors._();

  // Brand palette (from original APK hex values)
  static const night = Color(0xFF050E28);
  static const dark = Color(0xFF0A1840);
  static const mid = Color(0xFF132060);
  static const blue = Color(0xFF0052CC);
  static const cyan = Color(0xFF00D4FF);
  static const red = Color(0xFFCC0033);
  static const yellow = Color(0xFFFFCC00);
  static const green = Color(0xFF00802B);
  static const lime = Color(0xFF66FF99);
  static const white = Color(0xFFFFFFFF);

  // Hero colours
  static const catboyPrimary = Color(0xFF0041CC);
  static const catboyCyan = Color(0xFF00F0FF);
  static const owlettePrimary = Color(0xFFCC0033);
  static const owletteGold = Color(0xFFFFCC00);
  static const gekkoPrimary = Color(0xFF00802B);
  static const gekkoLime = Color(0xFF66FF99);
}

class AppTheme {
  AppTheme._();

  static ThemeData get dark => ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.night,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.cyan,
          secondary: AppColors.yellow,
          surface: AppColors.dark,
          error: AppColors.red,
        ),
        fontFamily: 'Roboto',
        textTheme: _textTheme,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: AppColors.white,
          centerTitle: true,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.blue,
            foregroundColor: AppColors.white,
            textStyle: const TextStyle(
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
              fontSize: 16,
            ),
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            elevation: 8,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.cyan),
      );

  static const _textTheme = TextTheme(
    displayLarge: TextStyle(
      color: AppColors.cyan,
      fontWeight: FontWeight.w900,
      letterSpacing: 3,
    ),
    displayMedium: TextStyle(
      color: AppColors.yellow,
      fontWeight: FontWeight.w900,
      letterSpacing: 2,
    ),
    titleLarge: TextStyle(
      color: AppColors.white,
      fontWeight: FontWeight.w800,
      letterSpacing: 1.5,
    ),
    bodyLarge: TextStyle(color: AppColors.white),
    bodyMedium: TextStyle(color: AppColors.white, fontSize: 14),
    labelSmall: TextStyle(color: AppColors.cyan, letterSpacing: 2),
  );
}
