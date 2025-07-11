import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_routes.dart';
import '../../l10n/app_localizations.dart';
import '../pages/home_page.dart';
import '../providers/language_code_provider.dart';
import '../providers/theme_provider.dart';

/// This widget is the [MaterialApp] of the application, which contains all
/// important info about layout, theme, routes, localization, etc.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    final languageCode = Provider.of<LanguageCodeProvider>(
      context,
    ).languageCode;
    final locale = Locale(languageCode);

    return MaterialApp(
      title: 'Roam',
      debugShowCheckedModeBanner: false,

      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,

      locale: locale,

      theme: ThemeData(brightness: Brightness.light),
      darkTheme: ThemeData(brightness: Brightness.dark),

      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,

      routes: AppRoutes.appRoutes,
      initialRoute: HomePage.routeName,
    );
  }
}
