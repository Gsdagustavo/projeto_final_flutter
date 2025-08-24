import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';
import '../pages/auth/auth_page_switcher.dart';
import '../pages/auth/forgot_password_page.dart';
import '../pages/auth/login_page.dart';
import '../pages/auth/register_page.dart';
import '../pages/auth/splash_screen.dart';
import '../pages/home/home_page.dart';
import '../pages/settings/settings_page.dart';
import '../pages/travel/map_page.dart';
import 'app_routes.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: Routes.splash,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNavBar(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.home,
                pageBuilder: (context, state) =>
                    NoTransitionPage(child: const HomePage()),
              ),
            ],
          ),
          // StatefulShellBranch(
          //   routes: [
          //     GoRoute(
          //       path: Routes.registerTravel,
          //       pageBuilder: (context, state) =>
          //           NoTransitionPage(child: const RegisterTravelPage()),
          //     ),
          //   ],
          // ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.settings,
                pageBuilder: (context, state) =>
                    NoTransitionPage(child: const SettingsPage()),
              ),
            ],
          ),
        ],
      ),

      GoRoute(
        path: Routes.travelMap,
        pageBuilder: (context, state) => NoTransitionPage(child: TravelMap()),
      ),

      GoRoute(
        path: Routes.auth,
        pageBuilder: (context, state) =>
            NoTransitionPage(child: const AuthPageSwitcher()),
        routes: [
          GoRoute(
            path: Routes.login,
            pageBuilder: (context, state) =>
                NoTransitionPage(child: LoginPage()),
          ),
          GoRoute(
            path: Routes.register,
            pageBuilder: (context, state) =>
                NoTransitionPage(child: RegisterPage()),
          ),
          GoRoute(
            path: Routes.forgotPassword,
            pageBuilder: (context, state) =>
                NoTransitionPage(child: ForgotPasswordPage()),
          ),
        ],
      ),

      GoRoute(
        path: Routes.splash,
        pageBuilder: (context, state) =>
            NoTransitionPage(child: const SplashScreen()),
      ),
    ],
  );
}

class ScaffoldWithNavBar extends StatelessWidget {
  const ScaffoldWithNavBar({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _onItemTapped(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final as = AppLocalizations.of(context)!;

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationShell.currentIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: as.title_home),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.map),
          //   label: as.title_register_travel,
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: as.title_settings,
          ),
        ],
      ),
    );
  }
}
