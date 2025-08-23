import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_preferences_provider.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<UserPreferencesProvider>();
    final isDarkMode = state.isDarkMode;

    return IconButton(
      onPressed: state.toggleTheme,
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        transitionBuilder: (child, animation) {
          return RotationTransition(turns: animation, child: child);
        },
        child: Icon(
          isDarkMode ? Icons.dark_mode : Icons.light_mode,
          key: ValueKey<bool>(isDarkMode),
          color: isDarkMode ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}
