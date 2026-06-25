import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {

  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  LanguageProvider() {
    loadLanguage();
  }

  Future<void> loadLanguage() async {

    final prefs =
    await SharedPreferences.getInstance();

    String lang =
        prefs.getString("language") ?? "en";

    _locale = Locale(lang);

    notifyListeners();
  }

  Future<void> changeLanguage(
      String code) async {

    final prefs =
    await SharedPreferences.getInstance();

    await prefs.setString(
      "language",
      code,
    );

    _locale = Locale(code);

    notifyListeners();
  }
}