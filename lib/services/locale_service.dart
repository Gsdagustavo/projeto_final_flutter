import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';

/// Service class to handle language code persistence using [SharedPreferences]
///
/// [languageCodes]: A list of available language codes
/// [defaultLanguageCode]: The default language code of the app
class LocaleService {
  /// A list of available language codes
  static const languageCodes = ['en', 'es', 'pt'];

  /// The key used to load and save the current language code in
  /// [SharedPreferences]
  static const _languageCodeKey = 'languageCode';

  /// The default language code of the app
  static final defaultLanguageCode = languageCodes.first;

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

  Future<String> loadLanguageCode() async {
    final prefs = await SharedPreferences.getInstance();

    final languageCode = prefs.getString(_languageCodeKey);
    if (languageCode != null && languageCodes.contains(languageCode)) {
      return languageCode;
    }

    /// TODO: implement a better way of retrieving the device language code, since [window] is deprecated
    final deviceLanguageCode = window.locale.languageCode;
    final finalLanguageCode = languageCodes.contains(deviceLanguageCode)
        ? deviceLanguageCode
        : defaultLanguageCode;

    await prefs.setString(_languageCodeKey, finalLanguageCode);
    return finalLanguageCode;
  }
}

/// A custom exception that will be thrown if a language code is invalid
class InvalidLanguageCodeException implements Exception {
  /// The error message
  final String message;

  /// Default constructor
  InvalidLanguageCodeException(this.message);
}
