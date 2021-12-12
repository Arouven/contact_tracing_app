import 'package:geolocator/geolocator.dart';

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
const String checkEmailUrl = website + "flutter_login/checkUsername.php";
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
 