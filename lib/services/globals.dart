import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

// change as per requirements
const geolocatorAccuracy = LocationAccuracy.best;
const int timeToGetLocationPerMinute = 1; // get geolocation every x minutes
//const int timeToUploadPerMinute = 5; //6 * 60;//6 hours

//website config
//login register
const String website = 'https://contact-tracing-utm.000webhostapp.com/';
const String resetUrl = website + "flutter_login/reset.php";
const String getMobilesUrl = website + "apis/getMobiles.php";
const String updateMobileUrl = website + "apis/updateMobile.php";
const String updateMobilefmcTokenUrl =
    website + "apis/updateMobilefmcToken.php";
const String addMobileUrl = website + "apis/addMobile.php";
const String registerUrl = website + "flutter_login/register.php";
const String getUserInfoUrl = website + "apis/getUserInfo.php";
const String updateDateOfBirthUrl =
    website + "flutter_login/updateDateOfBirth.php";
const String updateAddressUrl = website + "flutter_login/updateAddress.php";
const String updateNameUrl = website + "flutter_login/updateName.php";
const String latestUpdateLocationsUrl =
    website + "apis/latestUpdateLocations.php";
//ftp
// const String ftpServer = 'ftpupload.net';
// const String ftpUser = 'epiz_28555904';
// const String ftpPassword = 'dCSxRI3N1p';
const String ftpServer = 'files.000webhost.com';
const String ftpUser = 'contact-tracing-utm';
const String ftpPassword = '12345678';
const String directoryToUpload = '/public_html/csv_to_sql/csvFiles/';

//notification
const String channelId = 'contacttracing';
const String channelName = 'your channel name';
const String channelDescription = 'your channel description';
const String flutterIcon = '@mipmap/ic_launcher';

class GlobalVariables {
  static String emailProp = '';

  ///unset all
  static Future unsetAll() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    emailProp = '';
    await prefs.clear();
  }

  //Email
  static Future setEmail({required String email}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    emailProp = email;
    await prefs.setString('email', email);
  }

  static Future getEmail() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    if (email == null || email == '') {
    } else {
      emailProp = email;
    }
    return email;
  }

//MobileNumber
  static Future setMobileNumber({required String mobileNumber}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('mobileNumber', mobileNumber);
  }

  static Future getMobileNumber() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('mobileNumber');
  }

  //JustLogin
  static Future setJustLogin({required bool justLogin}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('justLogin', justLogin);
  }

  static Future getJustLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('justLogin');
  }

//ShowConfirmInfected
  static Future setShowConfirmInfected(
      {required bool showConfirmInfected}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('showConfirmInfected', showConfirmInfected);
  }

  static Future getShowConfirmInfected() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('showConfirmInfected');
  }

//ShowContactWithInfected
  static Future setShowContactWithInfected(
      {required bool showContactWithInfected}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('showContactWithInfected', showContactWithInfected);
  }

  static Future getShowContactWithInfected() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('showContactWithInfected');
  }

  static Future setShowCleanUsers({required bool showCleanUsers}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('showCleanUsers', showCleanUsers);
  }

  static Future getShowCleanUsers() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('showCleanUsers');
  }

  static Future setShowTestingCenters(
      {required bool showTestingCenters}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('showTestingCenters', showTestingCenters);
  }

  static Future getShowTestingCenters() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('showTestingCenters');
  }

  static Future setShowMyLocation({required bool showMyLocation}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('showMyLocation', showMyLocation);
  }

  static Future getShowMyLocation() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('showMyLocation');
  }

  static Future setLocations({required String locations}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('Locations', locations);
  }

  static Future getLocations() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('Locations');
  }

  static Future setFileDirectory({required String fileDirectory}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('fileDirectory', fileDirectory);
  }

  static Future getFileDirectory() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('fileDirectory');
  }

  // static Future setForegroundServices({required bool showServices}) async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.setBool('backgroundServices', showServices);
  // }

  // static Future getForegroundServices() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.getBool('backgroundServices');
  // }

  static Future setNotifier({required bool notifier}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifier', notifier);
  }

  static Future getNotifier() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('notifier');
  }

  static Future setService({required bool service}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('service', service);
  }

  static Future getService() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('service') ?? false;
  }

  static Future setDarkTheme({required bool isDarkTheme}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkTheme', isDarkTheme);
  }

  static Future getDarkTheme() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('darkTheme');
  }

  static Future setBadgeNumber({required int badgeNumber}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('badgeNumber', badgeNumber);
  }

  static Future getBadgeNumber() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('badgeNumber');
  }
}
