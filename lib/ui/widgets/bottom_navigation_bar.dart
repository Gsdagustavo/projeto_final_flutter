import 'package:flutter/material.dart';
import 'package:projeto_final_flutter/l10n/app_localizations.dart';

import '../../core/constants/app_routes.dart';

class MyBottomNavigationBar extends StatelessWidget {
  const MyBottomNavigationBar({super.key});

  void _onItemTapped(BuildContext context, String routeName) {
    final currentRoute = ModalRoute.of(context)?.settings.name;
    if (currentRoute == routeName) return;

    Navigator.pushReplacementNamed(context, routeName);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final routes = appRoutes.keys.toList();
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
