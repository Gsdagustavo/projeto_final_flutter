import 'package:flutter/material.dart';

import '../../core/constants/app_routes.dart';
import '../../l10n/app_localizations.dart';
import '../pages/fab_page.dart';

/// This widget is a custom [BottomNavigationBar] that is used in [FabPage]
class MyBottomNavigationBar extends StatelessWidget {
  /// Constant constructor
  const MyBottomNavigationBar({super.key});

  void _onItemTapped(BuildContext context, String routeName) {
    final currentRoute = ModalRoute.of(context)?.settings.name;
    if (currentRoute == routeName) return;

    Navigator.pushReplacementNamed(context, routeName);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final routes = AppRoutes.appRoutes.keys.toList();
    final currentRoute = ModalRoute.of(context)?.settings.name;
    final currentIndex = routes.indexOf(currentRoute ?? '');

    return BottomNavigationBar(
      currentIndex: currentIndex == -1 ? 0 : currentIndex,

      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: loc.title_home),
        BottomNavigationBarItem(
          icon: Icon(Icons.travel_explore),
          label: loc.title_register_travel,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: loc.title_settings,
        ),
      ],

      onTap: (index) => _onItemTapped(context, routes[index]),
    );
  }
}
