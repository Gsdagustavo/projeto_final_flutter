import 'package:flutter/cupertino.dart';

import '../../presentation/pages/home_page.dart';
import '../../presentation/pages/register_travel_page.dart';
import '../../presentation/pages/settings_page.dart';

abstract final class AppRoutes {
  /// Defines the routes of the app and its pages
  static Map<String, Widget Function(BuildContext context)> get appRoutes => {
    HomePage.routeName: (_) => const HomePage(),
    RegisterTravelPage.routeName: (_) => RegisterTravelPage(),
    SettingsPage.routeName: (_) => const SettingsPage(),
  };
}
