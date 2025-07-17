import 'package:flutter/material.dart';

import '../../services/locale_service.dart';

/// A [ChangeNotifier] responsible for managing and persisting the app's
/// language settings
///
/// It uses [LocaleService] for data persistence
class LanguageCodeProvider with ChangeNotifier {
  /// Instance of [LocaleService] to call locale related methods
  final _localeService = LocaleService();

  /// The current language code (e.g: 'en', 'pt, 'es')
  String _languageCode = LocaleService.defaultLanguageCode;

  /// Calls the [_init] method to initialize the provider's internal state
  LanguageCodeProvider() {
    _init();
  }

  /// Internal method to initialize the [_languageCode]
  Future<void> _init() async {
    await loadLanguageCode();
  }

  /// Loads the saved language code from [LocaleService] and updates the
  /// internal state ([_languageCode])
  Future<void> loadLanguageCode() async {
    _languageCode = await _localeService.loadLanguageCode();
    notifyListeners();
  }

  /// Changes the current language code and persists the new value using
  /// [LocaleService]
  Future<void> changeLanguageCode({required String languageCode}) async {
    _languageCode = languageCode;
    await _localeService.saveLanguageCode(languageCode: languageCode);
    notifyListeners();
  }

  /// Returns the current [LanguageCode]
  String get languageCode => _languageCode;
}
