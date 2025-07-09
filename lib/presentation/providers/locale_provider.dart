import 'package:flutter/material.dart';

import '../../services/locale_service.dart';

class LanguageCodeProvider with ChangeNotifier {
  final _localeService = LocaleService();
  String _languageCode = LocaleService.defaultLanguageCode;

  LanguageCodeProvider() {
    _init();
  }

  _init() async {
    await loadLanguageCode();
  }

  Future<void> loadLanguageCode() async {
    _languageCode = await _localeService.loadLanguageCode();
    notifyListeners();
  }

  Future<void> changeLanguageCode({required String languageCode}) async {
    _languageCode = languageCode;
    await _localeService.saveLanguageCode(languageCode: languageCode);
    notifyListeners();
  }

  get languageCode => _languageCode;
}
