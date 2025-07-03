import '../../ui/pages/home_page.dart';
import '../../ui/pages/register_travel_page.dart';
import '../../ui/pages/settings_page.dart';

/// Defines the routes of the app and its pages
final appRoutes = {
  HomePage.routeName: (_) => const HomePage(),
  RegisterTravelPage.routeName: (_) => const RegisterTravelPage(),
  SettingsPage.routeName: (_) => const SettingsPage(),
};
