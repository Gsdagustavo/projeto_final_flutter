import 'package:flutter/material.dart';

/// Defines the application's theme configurations, including light and dark
/// themes, color schemes, typography, and component styling.
class AppTheme {
  // Travel Status Colors

  /// Color used to represent an upcoming travel in light mode.
  static const Color travelUpcomingLight = Color(0xFF3B82F6); // Blue

  /// Color used to represent an ongoing travel in light mode.
  static const Color travelOngoingLight = Color(0xFF10B981); // Green

  /// Color used to represent a finished travel in light mode.
  static const Color travelFinishedLight = Color(0xFF6B7280); // Gray

  /// Color used to represent an upcoming travel in dark mode.
  static const Color travelUpcomingDark = Color(0xFF60A5FA); // Lighter blue

  /// Color used to represent an ongoing travel in dark mode.
  static const Color travelOngoingDark = Color(0xFF34D399); // Lighter green

  /// Color used to represent a finished travel in dark mode.
  static const Color travelFinishedDark = Color(0xFF9CA3AF); // Lighter gray

  /// The [ThemeData] configuration for the application's **light theme**.
  ///
  /// Defines color schemes, text styles, card styling, buttons, inputs,
  /// app bar, bottom navigation bar, switches, and chips for light mode.
  static ThemeData get lightTheme {
    const lightColorScheme = ColorScheme.light(
      primary: Color(0xFF030213),
      onPrimary: Colors.white,
      secondary: Color(0xFFF1F2F6),
      onSecondary: Color(0xFF030213),
      surface: Colors.white,
      onSurface: Color(0xFF252525),
      error: Color(0xFFD4183D),
      onError: Colors.white,
      outline: Color(0x1A000000),
      outlineVariant: Color(0xFFECECF0),
      surfaceContainerHighest: Color(0xFFE9EBEF),
      onSurfaceVariant: Color(0xFF030213),
      inversePrimary: Color(0xFFFAFAFA),
      inverseSurface: Color(0xFF252525),
      onInverseSurface: Color(0xFFFAFAFA),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: lightColorScheme,
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32.0,
          fontWeight: FontWeight.w500,
          height: 1.5,
          color: Color(0xFF252525),
        ),
        displayMedium: TextStyle(
          fontSize: 28.0,
          fontWeight: FontWeight.w500,
          height: 1.5,
          color: Color(0xFF252525),
        ),
        displaySmall: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.w500,
          height: 1.5,
          color: Color(0xFF252525),
        ),
        headlineLarge: TextStyle(
          fontSize: 32.0,
          fontWeight: FontWeight.w500,
          height: 1.5,
          color: Color(0xFF252525),
        ),
        headlineMedium: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w500,
          height: 1.5,
          color: Color(0xFF252525),
        ),
        headlineSmall: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.w500,
          height: 1.5,
          color: Color(0xFF252525),
        ),
        titleLarge: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w500,
          height: 1.5,
          color: Color(0xFF252525),
        ),
        titleMedium: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w500,
          height: 1.5,
          color: Color(0xFF252525),
        ),
        titleSmall: TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.w500,
          height: 1.5,
          color: Color(0xFF252525),
        ),
        bodyLarge: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w400,
          height: 1.5,
          color: Color(0xFF252525),
        ),
        bodyMedium: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w400,
          height: 1.5,
          color: Color(0xFF252525),
        ),
        bodySmall: TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.w400,
          height: 1.5,
          color: Color(0xFF717182),
        ),
        labelLarge: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w500,
          height: 1.5,
          color: Color(0xFF252525),
        ),
        labelMedium: TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.w500,
          height: 1.5,
          color: Color(0xFF252525),
        ),
        labelSmall: TextStyle(
          fontSize: 10.0,
          fontWeight: FontWeight.w500,
          height: 1.5,
          color: Color(0xFF717182),
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 2,
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        shadowColor: Colors.black.withValues(alpha: 0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: const Color(0x1A000000),
            width: 1,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF030213),
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            height: 1.5,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF030213),
          side: const BorderSide(
            color: Color(0x1A000000),
            width: 1,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            height: 1.5,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xFF030213),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            height: 1.5,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF3F3F5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0x1A000000),
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0x1A000000), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0xFF030213),
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0xFFD4183D),
            width: 1,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        hintStyle: const TextStyle(
          color: Color(0xFF717182),
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Color(0xFF252525),
        elevation: 0,
        scrolledUnderElevation: 1,
        shadowColor: Colors.black,
        surfaceTintColor: Colors.white,
        titleTextStyle: TextStyle(
          color: Color(0xFF252525),
          fontSize: 20,
          fontWeight: FontWeight.w500,
          height: 1.5,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: Color(0xFF030213),
        unselectedItemColor: Color(0xFF717182),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
      switchTheme: SwitchThemeData(
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const Color(0xFF030213);
          }
          return const Color(0xFFCBCED4);
        }),
        thumbColor: WidgetStateProperty.all(Colors.white),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFFE9EBEF),
        labelStyle: const TextStyle(
          color: Color(0xFF030213),
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
    );
  }

  /// The [ThemeData] configuration for the application's **dark theme**.
  ///
  /// Defines color schemes, text styles, card styling, buttons, inputs,
  /// app bar, bottom navigation bar, switches, and chips for dark mode.
  static ThemeData get darkTheme {
    const darkColorScheme = ColorScheme.dark(
      primary: Color(0xFFFAFAFA),
      onPrimary: Color(0xFF343434),
      secondary: Color(0xFF434343),
      onSecondary: Color(0xFFFAFAFA),
      surface: Color(0xFF252525),
      onSurface: Color(0xFFFAFAFA),
      error: Color(0xFFEF4444),
      onError: Color(0xFFFAFAFA),
      outline: Color(0xFF434343),
      outlineVariant: Color(0xFF434343),
      surfaceContainerHighest: Color(0xFF434343),
      onSurfaceVariant: Color(0xFFFAFAFA),
      inversePrimary: Color(0xFF252525),
      inverseSurface: Color(0xFFFAFAFA),
      onInverseSurface: Color(0xFF252525),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: darkColorScheme,
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32.0,
          fontWeight: FontWeight.w500,
          height: 1.5,
          color: Color(0xFFFAFAFA),
        ),
        displayMedium: TextStyle(
          fontSize: 28.0,
          fontWeight: FontWeight.w500,
          height: 1.5,
          color: Color(0xFFFAFAFA),
        ),
        displaySmall: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.w500,
          height: 1.5,
          color: Color(0xFFFAFAFA),
        ),
        headlineLarge: TextStyle(
          fontSize: 32.0,
          fontWeight: FontWeight.w500,
          height: 1.5,
          color: Color(0xFFFAFAFA),
        ),
        headlineMedium: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w500,
          height: 1.5,
          color: Color(0xFFFAFAFA),
        ),
        headlineSmall: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.w500,
          height: 1.5,
          color: Color(0xFFFAFAFA),
        ),
        titleLarge: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w500,
          height: 1.5,
          color: Color(0xFFFAFAFA),
        ),
        titleMedium: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w500,
          height: 1.5,
          color: Color(0xFFFAFAFA),
        ),
        titleSmall: TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.w500,
          height: 1.5,
          color: Color(0xFFFAFAFA),
        ),
        bodyLarge: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w400,
          height: 1.5,
          color: Color(0xFFFAFAFA),
        ),
        bodyMedium: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w400,
          height: 1.5,
          color: Color(0xFFFAFAFA),
        ),
        bodySmall: TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.w400,
          height: 1.5,
          color: Color(0xFFB5B5B5),
        ),
        labelLarge: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w500,
          height: 1.5,
          color: Color(0xFFFAFAFA),
        ),
        labelMedium: TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.w500,
          height: 1.5,
          color: Color(0xFFFAFAFA),
        ),
        labelSmall: TextStyle(
          fontSize: 10.0,
          fontWeight: FontWeight.w500,
          height: 1.5,
          color: Color(0xFFB5B5B5),
        ),
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF252525),
        elevation: 2,
        // ignore: deprecated_member_use
        shadowColor: Colors.black.withOpacity(0.3),
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(
            color: Color(0xFF434343),
            width: 1,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFAFAFA),
          foregroundColor: const Color(0xFF343434),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            height: 1.5,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFFFAFAFA),
          side: const BorderSide(
            color: Color(0xFF434343),
            width: 1,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            height: 1.5,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xFFFAFAFA),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            height: 1.5,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF434343),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0xFF434343),
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF434343), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0xFFFAFAFA),
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0xFFEF4444),
            width: 1,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        hintStyle: const TextStyle(
          color: Color(0xFFB5B5B5),
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF252525),
        foregroundColor: Color(0xFFFAFAFA),
        elevation: 0,
        scrolledUnderElevation: 1,
        shadowColor: Colors.black,
        surfaceTintColor: Color(0xFF252525),
        titleTextStyle: TextStyle(
          color: Color(0xFFFAFAFA),
          fontSize: 20,
          fontWeight: FontWeight.w500,
          height: 1.5,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF252525),
        selectedItemColor: Color(0xFFFAFAFA),
        unselectedItemColor: Color(0xFFB5B5B5),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
      switchTheme: SwitchThemeData(
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const Color(0xFFFAFAFA);
          }
          return const Color(0xFF434343);
        }),
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const Color(0xFF343434);
          }
          return const Color(0xFFFAFAFA);
        }),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFF434343),
        labelStyle: const TextStyle(
          color: Color(0xFFFAFAFA),
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
    );
  }

  /// Returns the appropriate color for a travel status based on the theme
  /// brightness.
  ///
  /// - [status] is a string that can be `"upcoming"`, `"ongoing"`, `"finished"`
  /// or `"completed"`.
  /// - [isDark] determines whether to use dark theme colors or light theme
  /// colors
  ///
  /// Defaults to the finished travel color if the status is unrecognized.
  static Color getTravelStatusColor(String status, {required bool isDark}) {
    switch (status.toLowerCase()) {
      case 'upcoming':
        return isDark ? travelUpcomingDark : travelUpcomingLight;
      case 'ongoing':
        return isDark ? travelOngoingDark : travelOngoingLight;
      case 'finished':
      case 'completed':
        return isDark ? travelFinishedDark : travelFinishedLight;
      default:
        return isDark ? travelFinishedDark : travelFinishedLight;
    }
  }

  /// Returns a contrasting text color for the given travel status,
  /// ensuring sufficient readability against the status background color.
  ///
  /// - [status] is the current travel status.
  /// - [isDark] determines whether to return a color suitable for dark mode or
  /// light mode.
  static Color getTravelStatusTextColor(String status, {required bool isDark}) {
    return isDark ? const Color(0xFFF3F4F6) : Colors.white;
  }
}
