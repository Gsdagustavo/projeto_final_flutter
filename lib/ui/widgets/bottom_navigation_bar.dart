import 'package:flutter/material.dart';
import 'package:projeto_final_flutter/l10n/app_localizations.dart';

class MyBottomNavigationBar extends StatelessWidget {
  const MyBottomNavigationBar({super.key, required this.currentIndex});

  final int currentIndex;

  void _onItemTapped(BuildContext context, int index) {
    if (index == currentIndex) return;

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return BottomNavigationBar(
      currentIndex: currentIndex,

      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: loc.title_home),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: loc.title_settings,
        ),
      ],

      onTap: (index) => _onItemTapped(context, index),
    );
  }
}
