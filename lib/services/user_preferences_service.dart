import 'dart:io';
import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';

import '../core/exceptions/invalid_language_code_exception.dart';

class UserPreferencesService {
  static const String _profilePictureKey = 'profilePicture';
  static const String _darkModeKey = 'is_dark_mode';

  Future<File?> getCurrentProfilePicture() async {
    final prefs = await SharedPreferences.getInstance();

    final filePath = prefs.getString(_profilePictureKey);

    if (!prefs.containsKey(_profilePictureKey) || filePath == null) {
      return null;
    }

    return File(filePath);
  }

  Future<void> saveProfilePicture(File? profilePicture) async {
    final prefs = await SharedPreferences.getInstance();

    if (profilePicture == null) return;

    await prefs.setString(_profilePictureKey, profilePicture.path);
  }

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

  /// A list of available language codes
  static const languageCodes = ['en', 'es', 'pt'];

  /// The key used to load and save the current language code in
  /// [SharedPreferences]
  static const _languageCodeKey = 'languageCode';

  /// Saves the given [languageCode] to [SharedPreferences]
  ///
  /// Throws [InvalidLanguageCodeException] if the given [LanguageCode] is not
  /// valid
  Future<void> saveLanguageCode({required String languageCode}) async {
    if (languageCode.isEmpty) {
      throw InvalidLanguageCodeException('Language code cannot be empty');
    }

    if (!languageCodes.contains(languageCode)) {
      throw InvalidLanguageCodeException('Invalid language code');
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageCodeKey, languageCode);
  }

  /// Returns the current saved [language code] from [SharedPreferences]
  ///
  /// If there is no saved [language code] (user has not changed it previously),
  /// the device's language code will be be saved to [SharedPreferences] and be
  /// returned
  Future<String> loadLanguageCode() async {
    final prefs = await SharedPreferences.getInstance();

    final languageCode = prefs.getString(_languageCodeKey);
    if (languageCode != null && languageCodes.contains(languageCode)) {
      return languageCode;
    }

    /// TODO: implement a better way of retrieving the device's language code,
    /// since [window] is deprecated
    final deviceLanguageCode = window.locale.languageCode;
    final finalLanguageCode = languageCodes.contains(deviceLanguageCode)
        ? deviceLanguageCode
        : defaultLanguageCode;

    await prefs.setString(_languageCodeKey, finalLanguageCode);
    return finalLanguageCode;
  }

  /// The default language code of the app
  String get defaultLanguageCode {
    return languageCodes.first;
  }
}
