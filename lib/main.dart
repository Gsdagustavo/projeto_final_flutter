import 'package:flutter/material.dart';
import 'package:projeto_final_flutter/l10n/app_localizations.dart';
import 'package:projeto_final_flutter/ui/pages/home_page.dart';
import 'package:projeto_final_flutter/ui/pages/settings_page.dart';

import 'entities/enums.dart';

void main() {
  runApp(const MyApp());
}

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