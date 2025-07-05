import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../ui/pages/home_page.dart';
import '../../ui/pages/register_travel_page.dart';
import '../../ui/pages/settings_page.dart';

abstract final class AppRoutes {
  /// Defines the routes of the app and its pages
  static Map<String, Widget Function(BuildContext context)> get appRoutes => {
    HomePage.routeName: (_) => const HomePage(),
    RegisterTravelPage.routeName: (_) => RegisterTravelPage(),
    SettingsPage.routeName: (_) => const SettingsPage(),
  };
}
