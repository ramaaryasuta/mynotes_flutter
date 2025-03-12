import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider with ChangeNotifier {
  Locale _locale = const Locale('en');
  Locale get locale => _locale;

  List<String> localeSupport = ['English', 'Bahasa Indonesia', '中国人', '日本語'];

  LocaleProvider() {
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    String? langCode = prefs.getString('locale');

    if (langCode != null) {
      _locale = Locale(langCode);
      notifyListeners();
    }
  }

  Future<void> setLocale(String localeCode) async {
    _locale = Locale(localeCode);
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', localeCode);
  }
}
