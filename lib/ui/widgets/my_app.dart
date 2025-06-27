import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../pages/home_page.dart';
import '../pages/settings_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Roam',
      debugShowCheckedModeBanner: false,

      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,

      routes: {
        '/home': (_) => const HomePage(),
        '/settings': (_) => const SettingsPage(),
      },

      initialRoute: '/home',
    );
  }
}
