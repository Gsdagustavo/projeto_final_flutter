import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/exceptions/invalid_language_code_exception.dart';
import '../presentation/util/app_router.dart';

/// Service class to manage user preferences such as profile picture,
/// theme mode, and language.
///
/// This class handles loading and saving preferences using [SharedPreferences].
class UserPreferencesService {
  /// Key used to save the profile picture file path
  static const String _profilePictureKey = 'profilePicture';

  /// Key used to save dark mode preference
  static const String _darkModeKey = 'is_dark_mode';

  /// Available language codes for the app
  static const languageCodes = ['en', 'es', 'pt'];

  /// Key used to save the current language code in [SharedPreferences]
  static const _languageCodeKey = 'languageCode';

  /// Retrieves the current saved profile picture.
  ///
  /// Returns a [File] if a profile picture is saved; otherwise returns `null`.
  Future<File?> getCurrentProfilePicture() async {
    final prefs = await SharedPreferences.getInstance();
    final filePath = prefs.getString(_profilePictureKey);

    if (!prefs.containsKey(_profilePictureKey) || filePath == null) {
      return null;
    }

    return File(filePath);
  }

  /// Saves the given [profilePicture] file path into [SharedPreferences].
  ///
  /// Does nothing if [profilePicture] is `null`.
  Future<void> saveProfilePicture(File? profilePicture) async {
    final prefs = await SharedPreferences.getInstance();
    if (profilePicture == null) return;

    await prefs.setString(_profilePictureKey, profilePicture.path);
  }

  /// Saves the current theme mode into [SharedPreferences].
  ///
  /// [isDarkMode] determines whether dark mode is enabled.
  Future<void> saveMode({required bool isDarkMode}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_darkModeKey, isDarkMode);
  }

  /// Returns the current theme mode stored in [SharedPreferences].
  ///
  /// Returns `true` if dark mode is enabled.
  ///
  /// If the [_darkModeKey] does not have a value, returns the device's theme
  /// ([true] for dark mode, [false] for light mode)
  Future<bool> isDarkMode() async {
    final prefs = await SharedPreferences.getInstance();

    final platformBrightness = MediaQuery.of(
      AppRouter.navigatorKey.currentContext!,
    ).platformBrightness;

    return prefs.getBool(_darkModeKey) ?? platformBrightness == Brightness.dark;
  }

  /// Saves the given [languageCode] into [SharedPreferences].
  ///
  /// Throws [InvalidLanguageCodeException] if [languageCode] is invalid or
  /// empty.
  Future<void> saveLanguageCode({required String languageCode}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageCodeKey, languageCode);
  }

  /// Loads the current saved language code from [SharedPreferences].
  ///
  /// If no language code is saved, it defaults to the device's language if
  /// valid, otherwise the app's default language is saved and returned.
  Future<String> loadLanguageCode() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_languageCodeKey);

    if (languageCode != null && languageCodes.contains(languageCode)) {
      return languageCode;
    }

    final deviceLanguageCode = PlatformDispatcher.instance.locale.languageCode;
    final finalLanguageCode = languageCodes.contains(deviceLanguageCode)
        ? deviceLanguageCode
        : defaultLanguageCode;

    await prefs.setString(_languageCodeKey, finalLanguageCode);
    return finalLanguageCode;
  }

  /// Returns the default language code of the app.
  ///
  /// Defaults to the first element in [languageCodes].
  String get defaultLanguageCode {
    return languageCodes.first;
  }
}
