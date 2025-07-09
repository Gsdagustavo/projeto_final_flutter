import 'package:flutter/material.dart';

import '../../services/locale_service.dart';

class LocaleProvider with ChangeNotifier {
  final _localeService = LocaleService();
  var _locale = Locale(LocaleService.defaultLanguageCode);

  Future<void> changeLocale({required String languageCode}) async {
    _locale = Locale.fromSubtags(languageCode: languageCode);
    await _localeService.saveLanguageCode(languageCode: languageCode);
    notifyListeners();
  }

  Future<void> loadLocale() async {
    final languageCode = await _localeService.loadLanguageCode();
    _locale = Locale(languageCode);
    notifyListeners();
  }

  Locale get locale => _locale;
}
