import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

// change as per requirements
const geolocatorAccuracy = LocationAccuracy.best;
const int timeToGetLocationPerMinute = 1; // get geolocation every x minutes
const int timeToUploadPerMinute = 5; //6 * 60;//6 hours

//website config
//login register
const String website = 'https://contact-tracing-utm.000webhostapp.com/';
//const String loginUrl = website + "flutter_login/login.php";
const String resetUrl = website + "flutter_login/reset.php";
const String getMobilesUrl = website + "apis/getMobiles.php";
const String updateMobileUrl = website + "apis/updateMobile.php";
const String updateMobilefmcTokenUrl =
    website + "apis/updateMobilefmcToken.php";
const String addMobileUrl = website + "apis/addMobile.php";
const String registerUrl = website + "flutter_login/register.php";
//const String checkEmailUrl = website + "flutter_login/checkUsername.php";
const String latestUpdateLocationsUrl =
    website + "apis/latestUpdateLocations.php";
//ftp
// const String ftpServer = 'ftpupload.net';
// const String ftpUser = 'epiz_28555904';
// const String ftpPassword = 'dCSxRI3N1p';
const String ftpServer = 'files.000webhost.com';
const String ftpUser = 'contact-tracing-utm';
const String ftpPassword = '12345678';

//notification
const String channelId = 'contacttracing';
const String channelName = 'your channel name';
const String channelDescription = 'your channel description';
const String flutterIcon = '@mipmap/ic_launcher';

class GlobalVariables {
  static setEmail({required String email}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
  }

  static setMobileNumber({required String mobileNumber}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('mobileNumber', mobileNumber);
  }

  static setJustLogin({required bool justLogin}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('justLogin', justLogin);
  }

  static setShowConfirmInfected({required bool showConfirmInfected}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('showConfirmInfected', showConfirmInfected);
  }

  static setShowContactWithInfected(
      {required bool showContactWithInfected}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('showContactWithInfected', showContactWithInfected);
  }

  static setShowCleanUsers({required bool showCleanUsers}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('showCleanUsers', showCleanUsers);
  }

  static setShowTestingCenters({required bool showTestingCenters}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('showTestingCenters', showTestingCenters);
  }

  static setShowMyLocation({required bool showMyLocation}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('showMyLocation', showMyLocation);
  }

  static setLocations({required String locations}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('Locations', locations);
  }

  static getEmail() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('email');
  }

  static getMobileNumber() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('mobileNumber');
  }

  static getJustLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('justLogin');
  }

  static getShowConfirmInfected() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('showConfirmInfected');
  }

  static getShowContactWithInfected() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('showContactWithInfected');
  }

  static getShowCleanUsers() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('showCleanUsers');
  }

  static getShowTestingCenters() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('showTestingCenters');
  }

  static getShowMyLocation() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('showMyLocation');
  }

  static getLocations() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('Locations');
  }
}
//global vars
//in register.dart
// prefs.setString('firstName', firstname);
// prefs.setString('lastName', lastname);
// prefs.setString('country', country);
// prefs.setString('address', address);
// prefs.setString('telephone', telephone);
// prefs.setString('email', email);
// prefs.setString('dateOfBirth', dateOfBirth);
// prefs.setString('firebaseuid', firebaseuid);
// prefs.setString("userId", data['userId']);
 // prefs.setString('latestUpdate', time);

//in main.dart
//  prefs.setBool('showTestingCenters', true);
//  prefs.setBool('showConfirmInfected', true);
//    prefs.setBool('showCleanUsers', true);
//   prefs.setBool('showContactWithInfected', true);
// prefs.setBool('showMyLocation', true);
  
//in live locator.dart
//  prefs.setBool('showTestingCenters', true);
//  prefs.setBool('showConfirmInfected', true);
//    prefs.setBool('showCleanUsers', true);
//   prefs.setBool('showContactWithInfected', true);
// prefs.setBool('showMyLocation', true);
//  prefs.setString('Locations', jsonResponse);
 