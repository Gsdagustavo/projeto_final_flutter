import 'package:flutter/material.dart';
import 'package:projeto_final_flutter/providers/theme_provider.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_routes.dart';
import '../../l10n/app_localizations.dart';
import '../pages/home_page.dart';

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
