import 'package:flutter/material.dart';

class ThemeProvider
    extends ChangeNotifier {

  bool isDark = true;

  ThemeMode get themeMode =>
      isDark
          ? ThemeMode.dark
          : ThemeMode.light;

  void toggleTheme() {

    isDark = !isDark;

    notifyListeners();

  }
}