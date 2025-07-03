import 'package:shared_preferences/shared_preferences.dart';

/// This service class contains util methods to manipulate the app's theme
/// using [SharedPreferences]
class ThemeService {
  static const String _darkModeKey = 'is_dark_mode';

  /// Saves [isDarkMode] into the [_darkModeKey]
  Future<void> saveMode({required bool isDarkMode}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_darkModeKey, isDarkMode);
  }

  /// Returns a [Future] that corresponds to the current state of the app's
  /// theme (whether is in dark mode or not)
  Future<bool> getMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_darkModeKey) ?? false;
  }
}
