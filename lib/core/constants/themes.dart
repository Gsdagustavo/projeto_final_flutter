import 'package:flutter/material.dart';

/// Defines the complete [ThemeData] for the [light theme].
ThemeData getTravelAppTheme() {
  const primaryColor = Color(0xFFF0934F);
  const primaryVariantColor = Color(0xFFC46A2E);
  const secondaryColor = Color(0xFF5A7C6B);
  const backgroundColor = Color(0xFFF7F4F0);
  const surfaceColor = Color(0xFFFFFFFF);
  const errorColor = Color(0xFFB00020);

  const onPrimary = Colors.white;
  const onBackground = Color(0xFF333333);
  const onPrimaryHint = Color(0xFFBDBDBD);

  const appBarColor = Color(0xFFD67735);
  const bottomNavBarColor = Color(0xFFE0D8D0);

  const greyIconColor = Color(0xFF666666);

  return ThemeData(
    colorScheme: const ColorScheme(
      primary: primaryColor,
      primaryContainer: primaryVariantColor,
      secondary: secondaryColor,
      background: backgroundColor,
      surface: surfaceColor,
      error: errorColor,
      onPrimary: onPrimary,
      onSecondary: onPrimary,
      onBackground: onBackground,
      onSurface: onBackground,
      onError: Colors.white,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: backgroundColor,
    iconTheme: const IconThemeData(color: greyIconColor, size: 24.0),
    listTileTheme: ListTileThemeData(iconColor: greyIconColor),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.bold,
        color: onBackground,
      ),
      displayMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: onBackground,
      ),
      displaySmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: onBackground,
      ),
      bodyLarge: TextStyle(fontSize: 16, color: onBackground),
      bodyMedium: TextStyle(fontSize: 14, color: onBackground),
      bodySmall: TextStyle(fontSize: 12, color: onBackground),
      labelLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: onPrimary,
      ),
      labelSmall: TextStyle(fontSize: 12, color: onBackground, height: 1.2),
    ),
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: TextStyle(
        color: onPrimaryHint.withOpacity(0.7),
        fontStyle: FontStyle.italic,
      ),
      labelStyle: const TextStyle(color: secondaryColor),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: secondaryColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: primaryColor, width: 2.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: secondaryColor.withOpacity(0.5)),
      ),
    ),
    cardTheme: CardThemeData(
      color: surfaceColor,
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: onPrimary,
        backgroundColor: primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        elevation: 5.0,
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: appBarColor,
      foregroundColor: onPrimary,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: bottomNavBarColor,
      selectedItemColor: primaryColor,
      unselectedItemColor: greyIconColor,
    ),
  );
}

/// Defines the complete [ThemeData] for the [dark theme]
ThemeData getTravelAppDarkTheme() {
  const primaryColor = Color(0xFFF0934F);
  const primaryVariantColor = Color(0xFFC46A2E);
  const secondaryColor = Color(0xFF5A7C6B);
  const backgroundColor = Color(0xFF1E272E);
  const surfaceColor = Color(0xFF2E3942);
  const errorColor = Color(0xFFCF6679);

  const onPrimary = Colors.white;
  const onBackground = Color(0xFFEEEEEE);
  const onPrimaryHint = Color(0xFFB0B0B0);

  const greyIconColorDark = Color(0xFFAAAAAA);

  return ThemeData(
    colorScheme: const ColorScheme(
      primary: primaryColor,
      primaryContainer: primaryVariantColor,
      secondary: secondaryColor,
      background: backgroundColor,
      surface: surfaceColor,
      error: errorColor,
      onPrimary: onPrimary,
      onSecondary: onPrimary,
      onBackground: onBackground,
      onSurface: onBackground,
      onError: Colors.black,
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: backgroundColor,
    iconTheme: const IconThemeData(color: greyIconColorDark, size: 24.0),
    listTileTheme: ListTileThemeData(
      iconColor: greyIconColorDark,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.bold,
        color: onBackground,
      ),
      displayMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: onBackground,
      ),
      displaySmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: onBackground,
      ),
      bodyLarge: TextStyle(fontSize: 16, color: onBackground),
      bodyMedium: TextStyle(fontSize: 14, color: onBackground),
      bodySmall: TextStyle(fontSize: 12, color: onBackground),
      labelLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: onPrimary,
      ),
      labelSmall: TextStyle(fontSize: 12, color: onBackground, height: 1.2),
    ),
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: TextStyle(
        color: onPrimaryHint.withOpacity(0.7),
        fontStyle: FontStyle.italic,
      ),
      labelStyle: const TextStyle(color: onPrimaryHint),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: onPrimaryHint),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: primaryColor, width: 2.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: onPrimaryHint.withOpacity(0.5)),
      ),
    ),
    cardTheme: CardThemeData(
      color: surfaceColor,
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: onPrimary,
        backgroundColor: primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        elevation: 5.0,
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFB15F29),
      foregroundColor: onPrimary,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF141920),
      selectedItemColor: primaryColor,
      unselectedItemColor: greyIconColorDark,
    ),
  );
}

/// Custom [ThemeExtension] for the success color
class _SuccessColorExtension extends ThemeExtension<_SuccessColorExtension> {
  const _SuccessColorExtension({required this.successColor});

  final Color successColor;

  @override
  _SuccessColorExtension copyWith({Color? successColor}) {
    return _SuccessColorExtension(
      successColor: successColor ?? this.successColor,
    );
  }

  @override
  _SuccessColorExtension lerp(
    covariant ThemeExtension<_SuccessColorExtension>? other,
    double t,
  ) {
    if (other is! _SuccessColorExtension) {
      return this;
    }
    return _SuccessColorExtension(
      successColor: Color.lerp(successColor, other.successColor, t)!,
    );
  }
}
