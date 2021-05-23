import 'package:shared_preferences/shared_preferences.dart';

class SP {
  String fullFilePath;
  main() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    this.fullFilePath = prefs.getString("fullFilePath");
    prefs.getString("UserName");
    prefs.getString("mobileID");
  }
}
