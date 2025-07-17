import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';

class ThemeToggleButton extends StatelessWidget {
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
