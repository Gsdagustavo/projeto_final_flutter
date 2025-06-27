import 'package:flutter/material.dart';
import 'package:projeto_final_flutter/providers/theme_provider.dart';
import 'package:projeto_final_flutter/ui/pages/register_travel_page.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../pages/home_page.dart';
import '../pages/settings_page.dart';

final appRoutes = {
  HomePage.routeName: (_) => const HomePage(),
  RegisterTravelPage.routeName: (_) => const RegisterTravelPage(),
  SettingsPage.routeName: (_) => const SettingsPage(),
};

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      builder: (context, child) {
        final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

        return MaterialApp(
          title: 'Roam',
          debugShowCheckedModeBanner: false,

          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,

          theme: ThemeData(brightness: Brightness.light),
          darkTheme: ThemeData(brightness: Brightness.dark),

          themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,

          routes: appRoutes,
          initialRoute: HomePage.routeName,
        );
      },
    );
  }
}
