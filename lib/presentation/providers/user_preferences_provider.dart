import 'package:flutter/material.dart';

import '../../services/user_preferences_service.dart';

/// A [ChangeNotifier] provider responsible for managing user preferences
/// such as theme mode and language code. It loads and persists these
/// preferences using [UserPreferencesService].
class UserPreferencesProvider with ChangeNotifier {
  /// The current language code (e.g., 'en', 'pt', 'es').
  String languageCode = UserPreferencesService().defaultLanguageCode;

  /// Whether the dark theme is enabled.
  bool _isDarkMode = false;

  /// Creates an instance of [UserPreferencesProvider] and initializes the
  /// internal state by loading persisted user preferences.
  UserPreferencesProvider() {
    _init();
  }

  /// Internal method to initialize user preferences by loading the saved
  /// language code and theme mode.
  Future<void> _init() async {
    await loadLanguageCode();
    _isDarkMode = await UserPreferencesService().getMode();
    notifyListeners();
  }

  /// Loads the saved language code from [UserPreferencesService] and updates
  /// the current state.
  Future<void> loadLanguageCode() async {
    languageCode = await UserPreferencesService().loadLanguageCode();
    notifyListeners();
  }

  /// Changes the current language code and persists the new value using
  /// [UserPreferencesService].
  ///
  /// - [languageCode]: The new language code to apply.
  Future<void> changeLanguageCode({required String languageCode}) async {
    this.languageCode = languageCode;
    await UserPreferencesService().saveLanguageCode(languageCode: languageCode);
    notifyListeners();
  }

  /// Toggles between dark and light themes and persists the choice using
  /// [UserPreferencesService].
  void toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await UserPreferencesService().saveMode(isDarkMode: _isDarkMode);
    notifyListeners();
  }

  /// Returns whether dark mode is currently enabled.
  bool get isDarkMode => _isDarkMode;
}
