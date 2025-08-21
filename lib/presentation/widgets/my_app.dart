import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/constants/themes.dart';
import '../../l10n/app_localizations.dart';
import '../providers/user_preferences_provider.dart';
import '../util/app_router.dart';

/// This widget is the [MaterialApp] of the application, which contains all
/// important info about layout, theme, routes, localization, etc.
class MyApp extends StatelessWidget {
  /// Constant constructor
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ---- THEME RELATED ----
    final isDarkMode = Provider.of<UserPreferencesProvider>(context).isDarkMode;

    final baseDarkTheme = getTravelAppDarkTheme();
    final baseTheme = getTravelAppTheme();

    final theme = baseTheme.copyWith(
      textTheme: GoogleFonts.quicksandTextTheme(baseTheme.textTheme),
    );

    final darkTheme = baseDarkTheme.copyWith(
      textTheme: GoogleFonts.quicksandTextTheme(baseDarkTheme.textTheme),
    );

    // ---- LANGUAGE RELATED ----
    final languageCode = Provider.of<UserPreferencesProvider>(
      context,
    ).languageCode;
    final locale = Locale(languageCode);

    return MaterialApp.router(
      title: 'Roam',
      debugShowCheckedModeBanner: false,

      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: locale,

      theme: theme,
      darkTheme: darkTheme,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,

      routerConfig: AppRouter.router,
    );
  }
}
