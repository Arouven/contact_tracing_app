import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;
  bool get isDarkMode => themeMode == ThemeMode.dark;

  void toggleTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
// import 'package:flutter/material.dart';
// import '../services/storage_manager.dart';

// class ThemeNotifier with ChangeNotifier {
//   final darkTheme = ThemeData(
//     primarySwatch: Colors.grey,
//     primaryColor: Colors.black,
//     brightness: Brightness.dark,
//     backgroundColor: const Color(0xFF212121),
//     accentColor: Colors.white,
//     accentIconTheme: IconThemeData(color: Colors.black),
//     dividerColor: Colors.black12,
//   );

//   final lightTheme = ThemeData(
//     primarySwatch: Colors.grey,
//     primaryColor: Colors.white,
//     brightness: Brightness.light,
//     backgroundColor: const Color(0xFFE5E5E5),
//     accentColor: Colors.black,
//     accentIconTheme: IconThemeData(color: Colors.white),
//     dividerColor: Colors.white54,
//   );