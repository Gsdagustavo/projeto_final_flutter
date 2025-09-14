import 'package:flutter/material.dart';

import '../../domain/entities/enums.dart';

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
      primary: Color(0xFF4A5568),
      // Softer dark gray instead of almost black
      onPrimary: Colors.white,
      secondary: Color(0xFFF7FAFC),
      // Slightly warmer light background
      onSecondary: Color(0xFF2D3748),
      // Softer dark text
      surface: Color(0xFFFFFFFE),
      // Slightly off-white for warmth
      onSurface: Color(0xFF2D3748),
      // Softer dark text instead of harsh black
      error: Color(0xFFE53E3E),
      // Slightly softer red
      onError: Colors.white,
      outline: Color(0x33000000),
      // More visible outline
      outlineVariant: Color(0xFFE2E8F0),
      // Warmer gray
      surfaceContainerHighest: Color(0xFFF1F5F9),
      // Warmer container color
      onSurfaceVariant: Color(0xFF4A5568),
      // Consistent with primary
      inversePrimary: Color(0xFFFFFFFE),
      inverseSurface: Color(0xFF2D3748),
      onInverseSurface: Color(0xFFFFFFFE),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: lightColorScheme,
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32.0,
          fontWeight: FontWeight.w500,
          height: 1.5,
          color: Color(0xFF1A202C), // Softer dark text
        ),
        displayMedium: TextStyle(
          fontSize: 28.0,
          fontWeight: FontWeight.w500,
          height: 1.5,
          color: Color(0xFF1A202C),
        ),
        displaySmall: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.w500,
          height: 1.5,
          color: Color(0xFF1A202C),
        ),
        headlineLarge: TextStyle(
          fontSize: 32.0,
          fontWeight: FontWeight.w500,
          height: 1.5,
          color: Color(0xFF1A202C),
        ),
        headlineMedium: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w500,
          height: 1.5,
          color: Color(0xFF1A202C),
        ),
        headlineSmall: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.w500,
          height: 1.5,
          color: Color(0xFF1A202C),
        ),
        titleLarge: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w500,
          height: 1.5,
          color: Color(0xFF2D3748),
        ),
        titleMedium: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w500,
          height: 1.5,
          color: Color(0xFF2D3748),
        ),
        titleSmall: TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.w500,
          height: 1.5,
          color: Color(0xFF2D3748),
        ),
        bodyLarge: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w400,
          height: 1.5,
          color: Color(0xFF2D3748),
        ),
        bodyMedium: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w400,
          height: 1.5,
          color: Color(0xFF2D3748),
        ),
        bodySmall: TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.w400,
          height: 1.5,
          color: Color(0xFF718096), // Softer gray for secondary text
        ),
        labelLarge: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w500,
          height: 1.5,
          color: Color(0xFF2D3748),
        ),
        labelMedium: TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.w500,
          height: 1.5,
          color: Color(0xFF2D3748),
        ),
        labelSmall: TextStyle(
          fontSize: 10.0,
          fontWeight: FontWeight.w500,
          height: 1.5,
          color: Color(0xFF718096),
        ),
      ),
      cardTheme: CardThemeData(
        color: Color(0xFFFFFFFE),
        elevation: 2,
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        shadowColor: Colors.black.withValues(alpha: 0.08),
        // Softer shadow
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: const Color(0xFFE2E8F0),
            width: 1,
          ), // Softer border
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4A5568),
          // Softer button color
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
          foregroundColor: const Color(0xFF4A5568),
          // Softer outline button text
          side: const BorderSide(color: Color(0xFF4A5568), width: 1),
          // Matching border
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
          foregroundColor: const Color(0xFF4A5568), // Softer text button color
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
        fillColor: const Color(0xFFF7FAFC),
        // Warmer input background
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0xFFE2E8F0),
            width: 1,
          ), // Softer border
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0xFF4A5568),
            width: 2,
          ), // Softer focus border
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE53E3E), width: 1),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        hintStyle: const TextStyle(
          color: Color(0xFF718096), // Softer hint text
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFFFFFFE),
        // Slightly off-white
        foregroundColor: Color(0xFF2D3748),
        // Softer app bar text
        elevation: 0,
        scrolledUnderElevation: 1,
        shadowColor: Colors.black,
        surfaceTintColor: Color(0xFFFFFFFE),
        titleTextStyle: TextStyle(
          color: Color(0xFF2D3748),
          fontSize: 20,
          fontWeight: FontWeight.w500,
          height: 1.5,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFFFFFFFE),
        selectedItemColor: Color(0xFF4A5568),
        // Softer selected color
        unselectedItemColor: Color(0xFF718096),
        // Softer unselected color
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
            return const Color(
              0xFF3B82F6,
            ); // Blue switch track matching active buttons
          }
          return const Color(0xFFCBD5E0); // Darker inactive track
        }),
        thumbColor: WidgetStateProperty.all(Colors.white),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFFE2E8F0), // Darker chip background
        labelStyle: const TextStyle(
          color: Color(0xFF3B82F6), // Blue chip text matching active buttons
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
          side: const BorderSide(color: Color(0xFF434343), width: 1),
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
          side: const BorderSide(color: Color(0xFF434343), width: 1),
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
          borderSide: const BorderSide(color: Color(0xFF434343), width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF434343), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFFAFAFA), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1),
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
  static Color getTravelStatusColor(
    TravelStatus status, {
    required bool isDark,
  }) {
    switch (status) {
      case TravelStatus.upcoming:
        return isDark ? travelUpcomingDark : travelUpcomingLight;
      case TravelStatus.ongoing:
        return isDark ? travelOngoingDark : travelOngoingLight;
      case TravelStatus.finished:
        return isDark ? travelFinishedDark : travelFinishedLight;
    }
  }

  /// Returns a contrasting text color for the given travel status,
  /// ensuring sufficient readability against the status background color.
  ///
  /// - [isDark] determines whether to return a color suitable for dark mode or
  /// light mode.
  static Color getTravelStatusTextColor({required bool isDark}) {
    return isDark ? const Color(0xFFF3F4F6) : Colors.white;
  }
}
