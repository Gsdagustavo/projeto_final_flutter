import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';

/// A custom [IconButton] that toggles the current [ThemeMode] by calling the
/// [ThemeProvider] provider
///
/// It is meant to be reused in many contexts
class ThemeToggleButton extends StatelessWidget {
  /// Constant constructor
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (_, themeState, __) {
        return IconButton(
          onPressed: themeState.toggleTheme,
          icon: Icon(
            themeState.isDarkMode ? Icons.dark_mode : Icons.light_mode,
          ),
        );
      },
    );
  }
}
