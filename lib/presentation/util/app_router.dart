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
import '../pages/travel/register_travel_page.dart';
import '../pages/travel/travel_details_page.dart';
import '../pages/travel/travel_map_page.dart';
import '../pages/travel/travel_route_page.dart';
import 'app_routes.dart';

/// Custom transition animations for different types of navigation
class PageTransitions {
  /// Slide transition from right to left (for forward navigation)
  static Page<T> slideFromRight<T extends Object?>(Widget child, GoRouterState state) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 250),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  /// Slide transition from bottom to top (for modal-style pages)
  static Page<T> slideFromBottom<T extends Object?>(Widget child, GoRouterState state) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 400),
      reverseTransitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeOutCubic;

        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  /// Fade transition (for subtle navigation)
  static Page<T> fade<T extends Object?>(Widget child, GoRouterState state) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 250),
      reverseTransitionDuration: const Duration(milliseconds: 200),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
          child: child,
        );
      },
    );
  }

  /// Scale and fade transition (for special pages like details)
  static Page<T> scaleAndFade<T extends Object?>(Widget child, GoRouterState state) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 350),
      reverseTransitionDuration: const Duration(milliseconds: 250),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const curve = Curves.easeOutQuart;

        return ScaleTransition(
          scale: Tween<double>(begin: 0.95, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: curve),
          ),
          child: FadeTransition(
            opacity: CurvedAnimation(parent: animation, curve: curve),
            child: child,
          ),
        );
      },
    );
  }

  /// No transition (for bottom navigation tabs to avoid jarring movement)
  static Page<T> noTransition<T extends Object?>(Widget child, GoRouterState state) {
    return NoTransitionPage<T>(
      key: state.pageKey,
      child: child,
    );
  }
}

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
                    PageTransitions.slideFromBottom(const HomePage(), state),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.registerTravel,
                pageBuilder: (context, state) =>
                    PageTransitions.noTransition(const RegisterTravelPage(), state),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.settings,
                pageBuilder: (context, state) =>
                    PageTransitions.noTransition(const SettingsPage(), state),
              ),
            ],
          ),
        ],
      ),

      /// Travel details pages (with special scale and fade animation)
      GoRoute(
        path: AppRoutes.travelDetails,
        pageBuilder: (context, state) {
          final travel = state.extra as Travel;
          debugPrint('travel passed to travel details page: $travel');
          return PageTransitions.scaleAndFade(TravelDetailsPage(travel: travel), state);
        },
      ),
      GoRoute(
        path: AppRoutes.travelMap,
        pageBuilder: (context, state) {
          return PageTransitions.slideFromRight(TravelMapPage(), state);
        },
      ),
      GoRoute(
        path: AppRoutes.travelRoute,
        pageBuilder: (context, state) {
          final travel = state.extra as Travel;
          return PageTransitions.slideFromRight(TravelRoutePage(travel: travel), state);
        },
      ),

      /// Authentication flow (with slide from bottom for modal feel)
      GoRoute(
        path: AppRoutes.auth,
        pageBuilder: (context, state) =>
            PageTransitions.slideFromBottom(const AuthPageSwitcher(), state),
        routes: [
          GoRoute(
            path: AppRoutes.login,
            pageBuilder: (context, state) =>
                PageTransitions.fade(LoginPage(), state),
          ),
          GoRoute(
            path: AppRoutes.register,
            pageBuilder: (context, state) =>
                PageTransitions.fade(RegisterPage(), state),
          ),
          GoRoute(
            path: AppRoutes.forgotPassword,
            pageBuilder: (context, state) =>
                PageTransitions.slideFromRight(ForgotPasswordPage(), state),
          ),
        ],
      ),

      /// Splash screen (no transition for initial load)
      GoRoute(
        path: AppRoutes.splash,
        pageBuilder: (context, state) =>
            PageTransitions.noTransition(const SplashScreen(), state),
      ),
    ],
  );
}

/// A [StatelessWidget] that wraps the app's main pages with a
/// [BottomNavigationBar] and handles switching between tabs with animations.
class ScaffoldWithNavBar extends StatefulWidget {
  /// Creates a scaffold with a navigation shell.
  const ScaffoldWithNavBar({super.key, required this.navigationShell});

  /// The shell used for managing bottom navigation.
  final StatefulNavigationShell navigationShell;

  @override
  State<ScaffoldWithNavBar> createState() => _ScaffoldWithNavBarState();
}

class _ScaffoldWithNavBarState extends State<ScaffoldWithNavBar>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// Handles taps on the bottom navigation bar items.
  void _onItemTapped(int index) {
    if (index != widget.navigationShell.currentIndex) {
      _animationController.reset();
      widget.navigationShell.goBranch(
        index,
        initialLocation: index == widget.navigationShell.currentIndex,
      );
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final as = AppLocalizations.of(context)!;
    final currentIndex = widget.navigationShell.currentIndex;

    return Scaffold(
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return SlideTransition(
            position: _slideAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: widget.navigationShell,
            ),
          );
        },
      ),
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