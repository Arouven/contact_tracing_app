import 'package:shared_preferences/shared_preferences.dart';

class SP {
  main() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.getString("fullFilePath");
    prefs.getString("nationalIdNumber");
    prefs.getString("mobileID");
  }
}
