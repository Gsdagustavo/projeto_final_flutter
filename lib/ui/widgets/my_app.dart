import 'package:flutter/material.dart';
import 'package:projeto_final_flutter/providers/theme_provider.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../pages/home_page.dart';
import '../pages/settings_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      builder: (context, child) {
        return Consumer<ThemeProvider>(
          builder: (_, themeState, __) {
            return MaterialApp(
              title: 'Roam',
              debugShowCheckedModeBanner: false,

              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,

              theme: ThemeData(brightness: Brightness.light),
              darkTheme: ThemeData(brightness: Brightness.dark),

              themeMode: themeState.isDarkMode
                  ? ThemeMode.dark
                  : ThemeMode.light,

              routes: {
                '/home': (_) => const HomePage(),
                '/settings': (_) => const SettingsPage(),
              },

              initialRoute: '/home',
            );
          },
        );
      },
    );
  }
}
