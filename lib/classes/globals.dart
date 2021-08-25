import 'package:geolocator/geolocator.dart';

// change as per requirements
const geolocatorAccuracy = LocationAccuracy.best;
const int timeToGetLocationPerMinute = 1; // get geolocation every x minutes
const int timeToUploadPerMinute = 5; //6 * 60;//6 hours

//website config
//login register
const String website = 'https://contact-tracing-utm.000webhostapp.com/';
const String loginUrl = website + "flutter_login/login.php";
const String registerUrl = website + "flutter_login/register.php";
const String latestUpdateLocationsUrl =
    website + "apis/latestUpdateLocations.php";
//ftp
const String ftpServer = 'ftpupload.net';
const String ftpUser = 'epiz_28555904';
const String ftpPassword = 'dCSxRI3N1p';
String fileName;
String mobileID;
String nationalIdNumber;

//in register.dart
// final SharedPreferences prefs = await SharedPreferences.getInstance();
// prefs.setString('firstName', firstname);
// prefs.setString('lastName', lastname);
// prefs.setString('country', country);
// prefs.setString('address', address);
// prefs.setString('telephone', telephone);
// prefs.setString('email', email);
// prefs.setString('dateOfBirth', dateOfBirth);
// prefs.setString('nationalIdNumber', nationalIdNumber);
// prefs.setString('username', username);
// prefs.setString('password', password);
// prefs.setString("userId", data['userId']);

// class Globals {
//   main() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     fileName = prefs.getString("fileName");
//     nationalIdNumber = prefs.getString("nationalIdNumber");
//     mobileId = prefs.getString("mobileId");
//   }
// }
