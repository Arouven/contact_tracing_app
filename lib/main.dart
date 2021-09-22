import 'dart:async';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

import 'pages/Location/live_geolocator.dart';
import 'pages/Mobile/addMobile.dart';
import './classes/globals.dart';
import './classes/uploadClass.dart';
import './classes/write.dart';
import 'pages/Login/register.dart';
import 'pages/Login/login.dart';
import './pages/splash.dart';
import 'pages/Mobile/mobiles.dart';
import 'pages/Notification/notifications.dart';
import 'pages/Profile/profile.dart';

Writefile _wf = new Writefile();

void onStart() {
  WidgetsFlutterBinding.ensureInitialized();
  int counter = 0;
  final service = FlutterBackgroundService();
  service.onDataReceived.listen((event) {
    if (event["action"] == "setAsBackground") {
      service.setForegroundMode(false);
    }

    if (event["action"] == "stopService") {
      service.stopBackgroundService();
    }
  });

  // bring to foreground
  service.setForegroundMode(true);
  Timer.periodic(
    Duration(minutes: timeToGetLocationPerMinute),
    (timer) async {
      if (!(await service.isServiceRunning())) timer.cancel();
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: geolocatorAccuracy,
      );
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs.getString("username") != null) {
        _wf.writeToFile(
            '${position.latitude.toString()}',
            '${position.longitude.toString()}',
            '${position.accuracy.toString()}');
        if (counter > timeToUploadPerMinute) {
          UploadFile uploadFile = new UploadFile();
          uploadFile.uploadToServer();
          counter = 0;
        }
      }
      service.setNotificationInfo(
        title: "Contact tracing",
        content:
            "Updated at ${DateTime.now()} \nLatitude: ${position.latitude.toString()} \nLongitude: ${position.longitude.toString()}",
      );

      service.sendData(
        {"current_date": DateTime.now().toIso8601String()},
      );
      counter = counter + 1;
    },
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Geolocator.requestPermission();

  FlutterBackgroundService.initialize(onStart);

  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contact tracing',
      theme: ThemeData(
        primarySwatch: mapBoxBlue,
      ),
      home: SplashPage(),
      routes: <String, WidgetBuilder>{
        //HomePage.route: (context) => HomePage(),
        LiveGeolocatorPage.route: (context) => LiveGeolocatorPage(),
        SplashPage.route: (context) => SplashPage(),
        RegisterPage.route: (context) => RegisterPage(),
        LoginPage.route: (context) => LoginPage(),
        MobilePage.route: (context) => MobilePage(),
        AddMobilePage.route: (context) => AddMobilePage(),
        //UpdateMobilePage.route: (context) => UpdateMobilePage(),
        NotificationsPage.route: (context) => NotificationsPage(),
        ProfilePage.route: (context) => ProfilePage(),
      },
    );
  }
}

const int _bluePrimary = 0xFF395afa;
const MaterialColor mapBoxBlue = MaterialColor(
  _bluePrimary,
  <int, Color>{
    50: Color(0xFFE7EBFE),
    100: Color(0xFFC4CEFE),
    200: Color(0xFF9CADFD),
    300: Color(0xFF748CFC),
    400: Color(0xFF5773FB),
    500: Color(_bluePrimary),
    600: Color(0xFF3352F9),
    700: Color(0xFF2C48F9),
    800: Color(0xFF243FF8),
    900: Color(0xFF172EF6),
  },
);
