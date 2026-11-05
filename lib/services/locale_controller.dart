import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants/storage_keys.dart';

class LocaleController extends ChangeNotifier {
  static final LocaleController instance = LocaleController._internal();
  LocaleController._internal();

  Locale _locale = const Locale('ar');

  Locale get locale => _locale;
  bool get isArabic => _locale.languageCode == 'ar';

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCode = prefs.getString(StorageKeys.languageCode);
    if (savedCode == 'en' || savedCode == 'ar') {
      _locale = Locale(savedCode!);
    } else {
      // Default to Arabic
      _locale = const Locale('ar');
    }
    notifyListeners();
  }

  Future<void> setLocale(Locale newLocale) async {
    if (_locale.languageCode == newLocale.languageCode) return;
    _locale = newLocale;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(StorageKeys.languageCode, newLocale.languageCode);
  }

  Future<void> toggleLocale() async {
    final next = _locale.languageCode == 'ar'
        ? const Locale('en')
        : const Locale('ar');
    await setLocale(next);
  }
}
