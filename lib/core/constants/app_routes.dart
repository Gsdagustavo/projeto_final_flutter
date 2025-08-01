import 'package:flutter/cupertino.dart';

import '../../presentation/pages/auth/auth_page_switcher.dart';
import '../../presentation/pages/auth/forgot_password_page.dart';
import '../../presentation/pages/auth/login_page.dart';
import '../../presentation/pages/auth/register_page.dart';
import '../../presentation/pages/auth/splash_screen.dart';
import '../../presentation/pages/home_page.dart';
import '../../presentation/pages/register_travel_page.dart';
import '../../presentation/pages/settings_page.dart';
import '../../presentation/pages/map.dart';

/// Defines the routes of the app and its pages
final class AppRoutes {
  /// Returns the application's pages routes
  Map<String, Widget Function(BuildContext context)> get appRoutes => {
    /// Main pages
    HomePage.routeName: (_) => const HomePage(),
    RegisterTravelPage.routeName: (_) => const RegisterTravelPage(),
    SettingsPage.routeName: (_) => const SettingsPage(),
    TravelMap.routeName: (_) => const TravelMap(),

    /// Auth related pages
    SplashScreen.routeName: (_) => const SplashScreen(),
    AuthPageSwitcher.routeName: (_) => const AuthPageSwitcher(),
    LoginPage.routeName: (_) => const LoginPage(),
    RegisterPage.routeName: (_) => const RegisterPage(),
    ForgotPasswordPage.routeName: (_) => const ForgotPasswordPage(),
  };

  /// Defines the app's initial route
  static const String initialRoute = SplashScreen.routeName;
}
