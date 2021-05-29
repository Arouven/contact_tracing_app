import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

// change as per requirements
const geolocatorAccuracy = LocationAccuracy.best;
const int timeToUploadPerMinute = 6 * 60;
const String url = "http://192.168.42.194/flutter_login/check.php";
const String regis = "http://192.168.42.194/flutter_login/register.php";

String fileName;
String mobileID;
String nationalIdNumber;

class Globals {
  main() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    fileName = prefs.getString("fileName");
    nationalIdNumber = prefs.getString("nationalIdNumber");
    mobileID = prefs.getString("mobileID");
  }
}
