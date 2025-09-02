import 'package:flutter/material.dart';

class AppTheme {
  // Travel Status Colors
  static const Color travelUpcomingLight = Color(0xFF3B82F6); // Blue
  static const Color travelOngoingLight = Color(0xFF10B981); // Green
  static const Color travelFinishedLight = Color(0xFF6B7280); // Gray

  static const Color travelUpcomingDark = Color(0xFF60A5FA); // Lighter blue
  static const Color travelOngoingDark = Color(0xFF34D399); // Lighter green
  static const Color travelFinishedDark = Color(0xFF9CA3AF); // Lighter gray

  // Light Theme
  static ThemeData get lightTheme {
    const ColorScheme lightColorScheme = ColorScheme.light(
      // Core colors
      primary: Color(0xFF030213),
      // --primary
      onPrimary: Colors.white,

      // --primary-foreground
      secondary: Color(0xFFF1F2F6),
      // --secondary (approx oklch(0.95 0.0058 264.53))
      onSecondary: Color(0xFF030213),

      // --secondary-foreground
      surface: Colors.white,
      // --card
      onSurface: Color(0xFF252525),

      // --foreground (approx oklch(0.145 0 0))
      background: Colors.white,
      // --background
      onBackground: Color(0xFF252525),

      // --foreground
      error: Color(0xFFD4183D),
      // --destructive
      onError: Colors.white,

      // --destructive-foreground
      outline: Color(0x1A000000),
      // --border (rgba(0, 0, 0, 0.1))
      outlineVariant: Color(0xFFECECF0),

      // --muted
      surfaceVariant: Color(0xFFE9EBEF),
      // --accent
      onSurfaceVariant: Color(0xFF030213),

      // --accent-foreground
      inversePrimary: Color(0xFFFAFAFA),
      inverseSurface: Color(0xFF252525),
      onInverseSurface: Color(0xFFFAFAFA),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: lightColorScheme,

      // Typography
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
          color: Color(0xFF717182), // --muted-foreground
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

      // Card theme
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 2,
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // --radius: 0.625rem = 10px
          side: BorderSide(
            color: const Color(0x1A000000), // --border
            width: 1,
          ),
        ),
      ),

      // Button themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF030213),
          // --primary
          foregroundColor: Colors.white,
          // --primary-foreground
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
            color: Color(0x1A000000), // --border
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

      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF3F3F5),
        // --input-background
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0x1A000000), // --border
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
            color: Color(0xFF030213), // --primary
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0xFFD4183D), // --destructive
            width: 1,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        hintStyle: const TextStyle(
          color: Color(0xFF717182), // --muted-foreground
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),

      // App bar theme
      appBarTheme: const AppBarThemeData(
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

      // Bottom navigation bar theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: Color(0xFF030213),
        // --primary
        unselectedItemColor: Color(0xFF717182),
        // --muted-foreground
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

      // Switch theme
      switchTheme: SwitchThemeData(
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return const Color(0xFF030213); // --primary
          }
          return const Color(0xFFCBCED4); // --switch-background
        }),
        thumbColor: MaterialStateProperty.all(Colors.white),
      ),

      // Chip theme
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFFE9EBEF), // --accent
        labelStyle: const TextStyle(
          color: Color(0xFF030213), // --accent-foreground
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
    );
  }

  // Dark Theme
  static ThemeData get darkTheme {
    const ColorScheme darkColorScheme = ColorScheme.dark(
      // Core colors
      primary: Color(0xFFFAFAFA),
      // --primary (oklch(0.985 0 0))
      onPrimary: Color(0xFF343434),

      // --primary-foreground (oklch(0.205 0 0))
      secondary: Color(0xFF434343),
      // --secondary (oklch(0.269 0 0))
      onSecondary: Color(0xFFFAFAFA),

      // --secondary-foreground
      surface: Color(0xFF252525),
      // --card (oklch(0.145 0 0))
      onSurface: Color(0xFFFAFAFA),

      // --foreground
      background: Color(0xFF252525),
      // --background
      onBackground: Color(0xFFFAFAFA),

      // --foreground
      error: Color(0xFFEF4444),
      // --destructive (adjusted for dark)
      onError: Color(0xFFFAFAFA),

      // --destructive-foreground
      outline: Color(0xFF434343),
      // --border
      outlineVariant: Color(0xFF434343),

      // --muted
      surfaceVariant: Color(0xFF434343),
      // --accent
      onSurfaceVariant: Color(0xFFFAFAFA),

      // --accent-foreground
      inversePrimary: Color(0xFF252525),
      inverseSurface: Color(0xFFFAFAFA),
      onInverseSurface: Color(0xFF252525),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: darkColorScheme,

      // Typography
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
          color: Color(0xFFB5B5B5), // --muted-foreground (oklch(0.708 0 0))
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

      // Card theme
      cardTheme: CardThemeData(
        color: const Color(0xFF252525),
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.3),
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(
            color: Color(0xFF434343), // --border
            width: 1,
          ),
        ),
      ),

      // Button themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFAFAFA),
          // --primary
          foregroundColor: const Color(0xFF343434),
          // --primary-foreground
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
            color: Color(0xFF434343), // --border
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

      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF434343),
        // --input
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0xFF434343), // --border
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
            color: Color(0xFFFAFAFA), // --primary
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0xFFEF4444), // --destructive
            width: 1,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        hintStyle: const TextStyle(
          color: Color(0xFFB5B5B5), // --muted-foreground
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),

      // App bar theme
      appBarTheme: const AppBarThemeData(
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

      // Bottom navigation bar theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF252525),
        selectedItemColor: Color(0xFFFAFAFA),
        // --primary
        unselectedItemColor: Color(0xFFB5B5B5),
        // --muted-foreground
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

      // Switch theme
      switchTheme: SwitchThemeData(
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return const Color(0xFFFAFAFA); // --primary
          }
          return const Color(0xFF434343); // --switch-background (dark)
        }),
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return const Color(0xFF343434);
          }
          return const Color(0xFFFAFAFA);
        }),
      ),

      // Chip theme
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFF434343), // --accent
        labelStyle: const TextStyle(
          color: Color(0xFFFAFAFA), // --accent-foreground
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
    );
  }

  // Helper method to get travel status color
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

  // Helper method to get contrasting text color for travel status
  static Color getTravelStatusTextColor(String status, {required bool isDark}) {
    // All status colors have sufficient contrast with white/near-white text
    return isDark ? const Color(0xFFF3F4F6) : Colors.white;
  }
}
