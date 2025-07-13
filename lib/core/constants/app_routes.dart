import 'package:flutter/cupertino.dart';

import '../../presentation/pages/auth/auth_page_switcher.dart';
import '../../presentation/pages/auth/login_page.dart';
import '../../presentation/pages/auth/register_page.dart';
import '../../presentation/pages/auth/splash_screen.dart';
import '../../presentation/pages/home_page.dart';
import '../../presentation/pages/register_travel_page.dart';
import '../../presentation/pages/settings_page.dart';

abstract final class AppRoutes {
  /// Defines the routes of the app and its pages
  static Map<String, Widget Function(BuildContext context)> get appRoutes => {
    /// Auth related pages
    LoginPage.routeName: (_) => const LoginPage(),
    RegisterPage.routeName: (_) => const RegisterPage(),
    AuthPageSwitcher.routeName: (_) => const AuthPageSwitcher(),

    /// Other pages
    HomePage.routeName: (_) => const HomePage(),
    RegisterTravelPage.routeName: (_) => RegisterTravelPage(),
    SettingsPage.routeName: (_) => const SettingsPage(),
  };

  static const String initialRoute = SplashScreen.routeName;
}
