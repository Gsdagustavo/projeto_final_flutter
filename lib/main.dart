import 'package:flutter/material.dart';
import 'package:projeto_final_flutter/l10n/app_localizations.dart';
import 'package:projeto_final_flutter/pages/home_page.dart';
import 'package:projeto_final_flutter/pages/settings_page.dart';

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

extension IntlString on TransportTypes {
  String getIntlTransportType(BuildContext context) {
    final loc = AppLocalizations.of(context);

    switch (this) {
      case TransportTypes.car:
        return loc!.transport_type_car;
      case TransportTypes.bike:
        return loc!.transport_type_bike;
      case TransportTypes.bus:
        return loc!.transport_type_bus;
      case TransportTypes.plane:
        return loc!.transport_type_plane;
      case TransportTypes.cruise:
        return loc!.transport_type_cruise;
    }
  }
}
