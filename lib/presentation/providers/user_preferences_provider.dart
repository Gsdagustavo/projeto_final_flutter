import 'package:flutter/material.dart';

import '../../services/user_preferences_service.dart';

class UserPreferencesProvider with ChangeNotifier {
  /// The current language code (e.g: 'en', 'pt, 'es')
  String _languageCode = UserPreferencesService().defaultLanguageCode;

  /// Calls the [_init] method to initialize the provider's internal state
  UserPreferencesProvider() {
    _init();
  }

  /// Internal method to initialize the [_languageCode]
  Future<void> _init() async {
    await loadLanguageCode();
    _isDarkMode = await UserPreferencesService().getMode();
    notifyListeners();
  }

  /// Loads the saved language code from [LocaleService] and updates the
  /// internal state ([_languageCode])
  Future<void> loadLanguageCode() async {
    _languageCode = await UserPreferencesService().loadLanguageCode();
    notifyListeners();
  }

  /// Changes the current language code and persists the new value using
  /// [LocaleService]
  Future<void> changeLanguageCode({required String languageCode}) async {
    _languageCode = languageCode;
    await UserPreferencesService().saveLanguageCode(languageCode: languageCode);
    notifyListeners();
  }

  /// Toggles the current theme and save it to [SharedPreferences] using the
  /// [ThemeService] class
  void toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await UserPreferencesService().saveMode(isDarkMode: _isDarkMode);
    notifyListeners();
  }

  /// Returns the state of dark mode flag
  bool get isDarkMode => _isDarkMode;

  /// Returns the current [LanguageCode]
  String get languageCode => _languageCode;

  set languageCode(String value) {
    _languageCode = value;
  }

  bool _isDarkMode = false;
}
