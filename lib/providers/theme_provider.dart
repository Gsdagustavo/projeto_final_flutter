import 'package:flutter/material.dart';

import '../services/theme_service.dart';

/// This is a provider for the theme state of the application
class ThemeProvider with ChangeNotifier {
  final ThemeService _themeService = ThemeService();

  bool _isDarkMode = false;

  /// Initializes the provider
  ThemeProvider() {
    _init();
  }

  void _init() async {
    _isDarkMode = await _themeService.getMode();
    notifyListeners();
  }

  /// Toggles the current theme and save it to [SharedPreferences] using the
  /// [ThemeService] class
  void toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await _themeService.saveMode(isDarkMode: _isDarkMode);
    notifyListeners();
  }

  /// Returns the state of dark mode flag
  bool get isDarkMode => _isDarkMode;
}
