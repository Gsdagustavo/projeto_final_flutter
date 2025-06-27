import 'package:flutter/material.dart';
import 'package:projeto_final_flutter/services/theme_service.dart';

class ThemeProvider with ChangeNotifier {
  final ThemeService _themeService = ThemeService();

  bool _isDarkMode = false;

  ThemeProvider() {
    _init();
  }

  void _init() async {
    _isDarkMode = await _themeService.getMode();
    notifyListeners();
  }

  void toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await _themeService.saveMode(_isDarkMode);
    notifyListeners();
  }

  bool get isDarkMode => _isDarkMode;
}
