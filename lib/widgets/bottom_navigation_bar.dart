import 'package:flutter/material.dart';

class _BottomNavigationBar extends StatefulWidget {
  const _BottomNavigationBar({super.key});

  @override
  State<_BottomNavigationBar> createState() => _BottomNavigationBarState();
}

class _BottomNavigationBarState extends State<_BottomNavigationBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,

      items: [BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home')],

      onTap: _onItemTapped,
    );
  }
}
