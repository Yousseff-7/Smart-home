import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {

  ThemeMode _themeMode =
      ThemeMode.dark;

  ThemeMode get themeMode =>
      _themeMode;

  bool get isDark =>
      _themeMode == ThemeMode.dark;

  ThemeProvider() {

    loadTheme();

  }

  Future loadTheme() async {

    final prefs =
    await SharedPreferences.getInstance();

    bool dark =
        prefs.getBool("darkMode") ?? true;

    _themeMode =
    dark
        ? ThemeMode.dark
        : ThemeMode.light;

    notifyListeners();

  }

  Future toggleTheme() async {

    final prefs =
    await SharedPreferences.getInstance();

    if (_themeMode == ThemeMode.dark) {

      _themeMode =
          ThemeMode.light;

      await prefs.setBool(
        "darkMode",
        false,
      );

    } else {

      _themeMode =
          ThemeMode.dark;

      await prefs.setBool(
        "darkMode",
        true,
      );

    }

    notifyListeners();

  }

}