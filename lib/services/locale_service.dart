import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';

class LocaleService {
  static const _languageCodes = ['en', 'es', 'pt'];
  static const _languageCodeKey = 'languageCode';
  static final defaultLanguageCode = _languageCodes.first;

  Future<void> saveLanguageCode({required String languageCode}) async {
    if (languageCode.isEmpty) {
      return;
    }

    if (!_languageCodes.contains(languageCode)) {
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageCodeKey, languageCode);
  }

  Future<String> loadLanguageCode() async {
    final prefs = await SharedPreferences.getInstance();

    final languageCode = prefs.getString(_languageCodeKey);
    if (languageCode != null && _languageCodes.contains(languageCode)) {
      return languageCode;
    }

    final deviceLanguageCode = window.locale.languageCode;
    final finalLanguageCode = _languageCodes.contains(deviceLanguageCode)
        ? deviceLanguageCode
        : defaultLanguageCode;

    await prefs.setString(_languageCodeKey, finalLanguageCode);
    return finalLanguageCode;
  }
}
