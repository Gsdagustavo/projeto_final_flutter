import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../l10n/app_localizations.dart';
import '../../providers/user_preferences_provider.dart';
import '../../util/app_routes.dart';
import '../../widgets/theme_toggle_button.dart';
import 'login_page.dart';
import 'register_page.dart';

/// This page controls the switch system between [LoginPage] and [RegisterPage]
/// using a [PageController]
///
/// It contains a visual selector (switch) that allows the user to switch
/// between the pages, and also a button to switch the app's theme mode
class AuthPageSwitcher extends StatefulWidget {
  /// Constant constructor
  const AuthPageSwitcher({super.key});

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
      duration: const Duration(milliseconds: _animationDuration),
      curve: Curves.easeInOut,
    );
  }

  Widget _buildSwitcherBar() {
    final as = AppLocalizations.of(context)!;

    return Stack(
      children: [
        const Positioned(right: 22, child: ThemeToggleButton()),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSwitcherOption(as.login, 0),
            const Padding(padding: EdgeInsets.all(12)),
            _buildSwitcherOption(AppLocalizations.of(context)!.register, 1),
          ],
        ),
      ],
    );
  }

  Widget _buildSwitcherOption(String text, int index) {
    final isSelected = index == _selectedIndex;
    final isDarkMode = Provider.of<UserPreferencesProvider>(
      context,
      listen: false,
    ).isDarkMode;

    final textStyle = Theme.of(context).textTheme.titleLarge?.copyWith(
      color: isSelected
          ? Theme.of(context).colorScheme.primary
          : Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.6),
      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
    );

    return InkWell(
      onTap: () => _switchPage(index),
      child: Column(
        children: [
          Text(text, style: textStyle),

          const Padding(padding: EdgeInsets.all(4)),
          AnimatedContainer(
            curve: Curves.easeInOut,
            duration: const Duration(milliseconds: _animationDuration),
            height: 2,
            width: isSelected ? 75 : 16,
            color: isDarkMode
                ? Theme.of(context).primaryColorLight
                : Theme.of(context).primaryColorDark,
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
          const Padding(padding: EdgeInsets.all(30)),
          _buildSwitcherBar(),
          const Padding(padding: EdgeInsets.all(22)),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },

              children: const [
                LoginPage(key: Key(AppRoutes.login)),
                RegisterPage(key: Key(AppRoutes.register)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
