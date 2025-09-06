import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_preferences_provider.dart';

/// A button that toggles the app's theme between light and dark modes.
///
/// The button icon updates dynamically based on the current theme,
/// using a smooth rotation animation.
class ThemeToggleButton extends StatelessWidget {
  /// Creates a theme toggle button.
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<UserPreferencesProvider>();
    final isDarkMode = state.isDarkMode;

    return IconButton(
      /// Toggles the theme when the button is pressed
      onPressed: state.toggleTheme,
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),

        /// Rotates the icon when switching between dark/light mode
        transitionBuilder: (child, animation) {
          return RotationTransition(turns: animation, child: child);
        },
        child: Icon(
          isDarkMode ? Icons.dark_mode : Icons.light_mode,
          key: ValueKey<bool>(isDarkMode),
          color: Theme.of(context).iconTheme.color,
        ),
      ),
    );
  }
}
