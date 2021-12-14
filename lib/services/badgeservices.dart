import 'package:shared_preferences/shared_preferences.dart';

class Badgeservices {
  static String badgeText = '';

  Badgeservices() {
    updateText();
  }
  updateText() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('badge') != null) {
      final badgeNumber = prefs.getString('badge') as String;
      badgeText = badgeNumber;
    } else {
      badgeText = '';
    }
  }
}
