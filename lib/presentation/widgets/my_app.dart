import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_routes.dart';
import '../../core/constants/themes.dart';
import '../../l10n/app_localizations.dart';
import '../providers/user_preferences_provider.dart';

/// This widget is the [MaterialApp] of the application, which contains all
/// important info about layout, theme, routes, localization, etc.
class MyApp extends StatelessWidget {
  /// Constant constructor
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<UserPreferencesProvider>(context).isDarkMode;
    final languageCode = Provider.of<UserPreferencesProvider>(
      context,
    ).languageCode;
    final locale = Locale(languageCode);

    return MaterialApp(
      title: 'Roam',
      debugShowCheckedModeBanner: false,

      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: locale,

      theme: Themes.lightTheme,
      darkTheme: Themes.darkTheme,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,

      routes: AppRoutes().appRoutes,
      initialRoute: AppRoutes.initialRoute,
    );
  }
}
