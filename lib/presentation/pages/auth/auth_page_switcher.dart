import 'package:flutter/material.dart';

import 'login_page.dart';
import 'register_page.dart';

class AuthPageSwitcher extends StatefulWidget {
  const AuthPageSwitcher({super.key});

  static const String routeName = '/authPageSwitcher';

  @override
  State<AuthPageSwitcher> createState() => _AuthPageSwitcherState();
}

class _AuthPageSwitcherState extends State<AuthPageSwitcher> {
  final _pageController = PageController();
  int _selectedIndex = 0;

  /// Animation duration, in Milliseconds
  static const int _animationDuration = 300;

  void _switchPage(int index) {
    setState(() {
      _selectedIndex = index;
    });

    _pageController.animateToPage(
      _selectedIndex,
      duration: Duration(milliseconds: _animationDuration),
      curve: Curves.easeInOut,
    );
  }

  Widget _buildSwitcherBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSwitcherOption('Login', 0),
        Padding(padding: EdgeInsetsGeometry.all(12)),
        _buildSwitcherOption('Register', 1),
      ],
    );
  }

  Widget _buildSwitcherOption(String text, int index) {
    final bool isSelected = index == _selectedIndex;
    return InkWell(
      onTap: () => _switchPage(index),
      child: Column(
        children: [
          Text(
            text,
            style: TextStyle(
              color: isSelected ? Theme.of(context).primaryColor : Colors.black,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 24,
            ),
          ),
          Padding(padding: EdgeInsets.all(4)),
          AnimatedContainer(
            curve: Curves.easeInOut,
            duration: Duration(milliseconds: _animationDuration),
            height: 2,
            width: isSelected ? 75 : 16,
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(padding: EdgeInsetsGeometry.all(30)),
          _buildSwitcherBar(),
          Padding(padding: EdgeInsets.all(22)),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },

              children: const [LoginPage(), RegisterPage()],
            ),
          ),
        ],
      ),
    );
  }
}
