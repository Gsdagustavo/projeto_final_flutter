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
  initialLocation: '/home',

  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ScaffoldWithNavBar(navigationShell: navigationShell);
      },

      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: 'home',
              path: '/home',
              pageBuilder: (context, state) =>
                  NoTransitionPage(child: const HomePage()),
            ),
          ],
        ),

        StatefulShellBranch(
          routes: [
            GoRoute(
              name: 'registerTravel',
              path: '/registerTravel',
              pageBuilder: (context, state) =>
                  NoTransitionPage(child: const RegisterTravelPage()),
            ),
          ],
        ),

        StatefulShellBranch(
          routes: [
            GoRoute(
              name: 'settings',
              path: '/settings',
              pageBuilder: (context, state) =>
                  NoTransitionPage(child: const SettingsPage()),
            ),
          ],
        ),
      ],
    ),

    GoRoute(
      name: 'travelMap',
      path: '/travelMap',

      pageBuilder: (context, state) => NoTransitionPage(child: TravelMap()),
    ),

    GoRoute(
      name: 'authPageSwitcher',
      path: '/authPageSwitcher',
      pageBuilder: (context, state) =>
          NoTransitionPage(child: const AuthPageSwitcher()),

      routes: [
        GoRoute(
          name: 'login',
          path: '/login',

          pageBuilder: (context, state) => NoTransitionPage(child: LoginPage()),
        ),

        GoRoute(
          name: 'register',
          path: '/register',

          pageBuilder: (context, state) =>
              NoTransitionPage(child: RegisterPage()),
        ),

        GoRoute(
          name: 'forgotPassword',
          path: '/forgotPassword',

          pageBuilder: (context, state) =>
              NoTransitionPage(child: ForgotPasswordPage()),
        ),
      ],
    ),

    GoRoute(
      name: 'splash',
      path: '/splash',
      pageBuilder: (context, state) =>
          NoTransitionPage(child: const SplashScreen()),
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
