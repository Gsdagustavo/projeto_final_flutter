import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/travel.dart';
import '../../l10n/app_localizations.dart';
import '../pages/auth/auth_page_switcher.dart';
import '../pages/auth/forgot_password_page.dart';
import '../pages/auth/login_page.dart';
import '../pages/auth/register_page.dart';
import '../pages/auth/splash_screen.dart';
import '../pages/home/home_page.dart';
import '../pages/settings/settings_page.dart';
import '../pages/travel/map_page.dart';
import '../pages/travel/register_travel_page.dart';
import '../pages/travel/travel_details_page.dart';
import '../pages/travel/travel_route_page.dart';
import 'app_routes.dart';

/// A centralized router using [GoRouter] for the application.
///
/// Handles both the main app navigation (with a bottom navigation bar) and
/// authentication or standalone pages.
class AppRouter {
  /// The global navigator key for the app.
  static final navigatorKey = GlobalKey<NavigatorState>();

  /// The configured [GoRouter] instance for the app.
  static final router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: AppRoutes.splash,
    routes: [
      /// Main app routes with bottom navigation bar
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNavBar(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                pageBuilder: (context, state) =>
                    NoTransitionPage(child: const HomePage()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.registerTravel,
                pageBuilder: (context, state) =>
                    NoTransitionPage(child: const RegisterTravelPage()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.settings,
                pageBuilder: (context, state) =>
                    NoTransitionPage(child: const SettingsPage()),
              ),
            ],
          ),
        ],
      ),

      /// Travel detail pages
      GoRoute(
        path: AppRoutes.travelDetails,
        pageBuilder: (context, state) {
          final travel = state.extra as Travel;
          debugPrint('travel passed to travel details page: $travel');
          return NoTransitionPage(child: TravelDetailsPage(travel: travel));
        },
      ),
      GoRoute(
        path: AppRoutes.travelMap,
        pageBuilder: (context, state) => NoTransitionPage(child: TravelMap()),
      ),
      GoRoute(
        path: AppRoutes.travelRoute,
        pageBuilder: (context, state) {
          final travel = state.extra as Travel;
          return NoTransitionPage(child: TravelRoutePage(travel: travel));
        },
      ),

      /// Authentication flow
      GoRoute(
        path: AppRoutes.auth,
        pageBuilder: (context, state) =>
            NoTransitionPage(child: const AuthPageSwitcher()),
        routes: [
          GoRoute(
            path: AppRoutes.login,
            pageBuilder: (context, state) =>
                NoTransitionPage(child: LoginPage()),
          ),
          GoRoute(
            path: AppRoutes.register,
            pageBuilder: (context, state) =>
                NoTransitionPage(child: RegisterPage()),
          ),
          GoRoute(
            path: AppRoutes.forgotPassword,
            pageBuilder: (context, state) =>
                NoTransitionPage(child: ForgotPasswordPage()),
          ),
        ],
      ),

      /// Splash screen
      GoRoute(
        path: AppRoutes.splash,
        pageBuilder: (context, state) =>
            NoTransitionPage(child: const SplashScreen()),
      ),
    ],
  );
}

/// A [StatelessWidget] that wraps the app's main pages with a
/// [BottomNavigationBar] and handles switching between tabs.
class ScaffoldWithNavBar extends StatelessWidget {
  /// Creates a scaffold with a navigation shell.
  const ScaffoldWithNavBar({super.key, required this.navigationShell});

  /// The shell used for managing bottom navigation.
  final StatefulNavigationShell navigationShell;

  /// Handles taps on the bottom navigation bar items.
  void _onItemTapped(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final as = AppLocalizations.of(context)!;

    final currentIndex = navigationShell.currentIndex;

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: AnimatedScale(
              scale: currentIndex == 0 ? 1.2 : 1.0,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              child: const Icon(Icons.home),
            ),
            label: as.title_home,
          ),
          BottomNavigationBarItem(
            icon: AnimatedScale(
              scale: currentIndex == 1 ? 1.2 : 1.0,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              child: const Icon(Icons.search),
            ),
            label: as.title_register_travel,
          ),
          BottomNavigationBarItem(
            icon: AnimatedScale(
              scale: currentIndex == 2 ? 1.2 : 1.0,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              child: const Icon(Icons.settings),
            ),
            label: as.title_settings,
          ),
        ],
      ),
    );
  }
}
