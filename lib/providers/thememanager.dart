import 'package:contact_tracing/services/globals.dart';
import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;
  bool get isDarkMode => themeMode == ThemeMode.dark;

  Future<void> toggleTheme(bool isOn) async {
    if (isOn) {
      themeMode = ThemeMode.dark;
      await GlobalVariables.setDarkTheme(isDarkTheme: true);
    } else {
      themeMode = ThemeMode.light;
      await GlobalVariables.setDarkTheme(isDarkTheme: false);
    }

    notifyListeners();
  }
}
