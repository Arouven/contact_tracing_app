import 'package:contact_tracing/services/globals.dart';
import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;
//  bool get isDarkMode => themeMode == ThemeMode.dark;
  //late bool _isDarkMode;  _isDarkMode = await GlobalVariables.getDarkTheme();
  Future<bool> isDark() async {
    try {
      bool _fromPref = await GlobalVariables.getDarkTheme();
      if (_fromPref == true) {
        themeMode = ThemeMode.dark;
        return true;
      } else {
        if (themeMode == ThemeMode.dark) {
          return true;
        } else {
          return false;
        }
      }
    } catch (e) {
      if (themeMode == ThemeMode.dark) {
        return true;
      } else {
        return false;
      }
    }
  }

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
