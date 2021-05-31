import 'dart:convert';
import 'dart:io';

import 'package:contact_tracing/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/io_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import './pages/live_geolocator.dart';
import 'dart:async';

import 'classes/globals.dart';
import 'classes/uploadClass.dart';
import 'classes/write.dart';
import 'pages/register.dart';
import 'pages/login.dart';

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
  Timer.periodic(Duration(minutes: 1), (timer) async {
    if (!(await service.isServiceRunning())) timer.cancel();
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: geolocatorAccuracy,
    );
    _wf.writeToFile('${position.latitude.toString()}',
        '${position.longitude.toString()}', '${position.accuracy.toString()}');
    if (counter > timeToUploadPerMinute) {
      UploadFile uploadFile = new UploadFile();
      uploadFile.uploadToServer();
      counter = 0;
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
  });
}

Future getData() async {
  var url = 'https://contacttracing.infinityfreeapp.com/connectOnline/get.php';
  http.Response response = await http.get(Uri.parse(url));
  var data = jsonDecode(response.body);
  print(data.toString());
}

Future xx() async {
  final ioc = new HttpClient();
  ioc.badCertificateCallback =
      (X509Certificate cert, String host, int port) => true;
  final https = new IOClient(ioc);
  var url = 'https://contact-tracing-utm.000webhostapp.com/get.php';

  https.post(Uri.parse(url)).then(
    (response) {
      // print("Reponse status : ${response.statusCode}");
      // print("Response body : ${response.body}");
      print(jsonDecode(response.body));
    },
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Geolocator.requestPermission();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString("nationalIdNumber", "P61548465161654816");
  await prefs.setString("mobileID", "200");
  var fn =
      '${prefs.getString("mobileID")}_${prefs.getString("nationalIdNumber")}_geolocatorbest.csv';
  await prefs.setString("fileName", fn);

  FlutterBackgroundService.initialize(onStart);

  runApp(MyApp());
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
      home: HomePage(), //HomePage(),
      routes: <String, WidgetBuilder>{
        HomePage.route: (context) => HomePage(),
        LiveGeolocatorPage.route: (context) => LiveGeolocatorPage(),
        RegisterPage.route: (context) => RegisterPage(),
        // LoginPage.route: (context) => LoginPage(),
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
