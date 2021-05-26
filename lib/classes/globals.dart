import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

String fileName;
String mobileID;
String nationalIdNumber;
const geolocatorAccuracy = LocationAccuracy.best;
const taskPushFtpServer = 'taskPushFtpServer';

class Globals {
  main() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    fileName = prefs.getString("fileName");
    nationalIdNumber = prefs.getString("nationalIdNumber");
    mobileID = prefs.getString("mobileID");
  }
}
