import 'package:flutter/cupertino.dart';

import '../../ui/pages/home_page.dart';
import '../../ui/pages/register_travel_page.dart';
import '../../ui/pages/settings_page.dart';

class AppRoutes {
  /// Defines the routes of the app and its pages
  Map<String, Widget Function(BuildContext context)> get appRoutes => {
    HomePage.routeName: (_) => const HomePage(),
    RegisterTravelPage.routeName: (_) => const RegisterTravelPage(),
    SettingsPage.routeName: (_) => const SettingsPage(),
  };
}
