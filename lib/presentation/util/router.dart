import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../pages/auth/auth_page_switcher.dart';
import '../pages/auth/forgot_password_page.dart';
import '../pages/auth/login_page.dart';
import '../pages/auth/register_page.dart';
import '../pages/auth/splash_screen.dart';
import '../pages/home_page.dart';
import '../pages/map_page.dart';
import '../pages/register_travel_page.dart';
import '../pages/settings_page.dart';

final router = GoRouter(
  initialLocation: SplashScreen.routeName,

  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ScaffoldWithNavBar(navigationShell: navigationShell);
      },

      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/',
              pageBuilder: (context, state) =>
                  NoTransitionPage(child: const HomePage()),
            ),
          ],
        ),

        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/registerTravel',
              pageBuilder: (context, state) =>
                  NoTransitionPage(child: const RegisterTravelPage()),
            ),
          ],
        ),

        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/settings',
              pageBuilder: (context, state) =>
                  NoTransitionPage(child: const SettingsPage()),
            ),
          ],
        ),
      ],
    ),

    GoRoute(
      path: '/travelMap',

      pageBuilder: (context, state) => NoTransitionPage(child: TravelMap()),
    ),

    GoRoute(
      path: '/authPageSwitcher',
      pageBuilder: (context, state) =>
          NoTransitionPage(child: const AuthPageSwitcher()),

      routes: [
        GoRoute(
          path: '/login',

          pageBuilder: (context, state) => NoTransitionPage(child: LoginPage()),
        ),

        GoRoute(
          path: '/register',

          pageBuilder: (context, state) =>
              NoTransitionPage(child: RegisterPage()),
        ),
      ],
    ),

    GoRoute(
      path: '/splash',
      pageBuilder: (context, state) =>
          NoTransitionPage(child: const SplashScreen()),
    ),

    GoRoute(
      path: ForgotPasswordPage.routeName,

      pageBuilder: (context, state) =>
          NoTransitionPage(child: ForgotPasswordPage()),
    ),
  ],
);

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
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationShell.currentIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Register Travel',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
