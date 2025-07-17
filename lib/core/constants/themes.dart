import 'package:flutter/material.dart';

/// Defines the App's themes
class Themes {
  /// Defines the App's light theme to a bunch of widgets and usecases
  static final ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.purple,
      brightness: Brightness.light,
    ),
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.purple,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.purple, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      prefixIconColor: Colors.purple,
    ),
  );

  /// Defines the App's dark theme to a bunch of widgets and usecases
  static final ThemeData darkTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.purple,
      brightness: Brightness.dark,
    ),
    useMaterial3: true,
    appBarTheme: AppBarTheme(
      backgroundColor: ColorScheme.fromSeed(
        seedColor: Colors.purple,
        brightness: Brightness.dark,
      ).primary,
      foregroundColor: Colors.white,
    ),
  );
}
