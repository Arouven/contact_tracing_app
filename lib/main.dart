// import 'dart:convert';
// import 'dart:io';
import 'dart:async';
// import 'dart:js';

import 'package:contact_tracing/pages/home.dart';
import 'package:contact_tracing/pages/mobiles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:http/io_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:splashscreen/splashscreen.dart';
// import 'package:http/http.dart' as http;

import './pages/live_geolocator.dart';
import './classes/globals.dart';
import './classes/uploadClass.dart';
import './classes/write.dart';
import './pages/register.dart';
import './pages/login.dart';
import './pages/splash.dart';

import 'package:contact_tracing/classes/globals.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

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
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString("fileName") != null) {
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
  });
}

void main() async {
  // final SharedPreferences prefs = await SharedPreferences.getInstance();
  //await prefs.setString('firstName', 'John');
  // await prefs.setString('lastName', 'Smith');
  // await prefs.setString('country', 'Mauritius');
  // await prefs.setString('address', 'Bambous');
  // await prefs.setString('telephone', '654654652');
  // await prefs.setString('email', 'JohnSmith@gmail.com');
  // await prefs.setString('dateOfBirth', '2000-01-13');
  // await prefs.setString('nationalIdNumber', 'J6465516549846513');
  // await prefs.setString('username', 'Johny');
  // await prefs.setString('password', '1234');
  // await prefs.setString('userId', '1');

  //if (await checkValues()) {
  //redirect to home (no need to register or login)
  // Navigator.push(
  //     context, MaterialPageRoute(builder: (context) => LiveGeolocatorPage()));
  //}
  WidgetsFlutterBinding.ensureInitialized();
  await Geolocator.requestPermission();
  // final SharedPreferences prefs = await SharedPreferences.getInstance();
  // await prefs.setString('firstName', 'John');
  // await prefs.setString('lastName', 'Smith');
  // await prefs.setString('country', 'Mauritius');
  // await prefs.setString('address', 'Bambous');
  // await prefs.setString('telephone', '654654652');
  // await prefs.setString('email', 'JohnSmith@gmail.com');
  // await prefs.setString('dateOfBirth', '2000-01-13');
  // await prefs.setString('nationalIdNumber', 'J6465516549846513');
  // await prefs.setString('username', 'Johny');
  // await prefs.setString('password', '1234');
  // await prefs.setString('userId', '1');
  //await prefs.setString("mobileId", "8");

  // var fn =
  //     '${prefs.getString("mobileId")}_${prefs.getString("username")}_geolocatorbest.csv';
  // await prefs.setString("fileName", fn);

///////

  FlutterBackgroundService.initialize(onStart);

  runApp(
    MyApp(),
  );
}

// class _MyAppState extends State<MyApp> {
//   Future<Widget> loadFromFuture() async {
//     // <fetch data from server. ex. login>

//     LoginPage()
//     return Future.value(new AfterSplash());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return new SplashScreen(
//         navigateAfterFuture: loadFromFuture(),
//         title: new Text(
//           'Welcome To Contact Tracing App',
//           style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
//         ),
//         image: new Image.network('https://i.imgur.com/TyCSG9A.png'),
//         backgroundColor: Colors.white,
//         styleTextUnderTheLoader: new TextStyle(),
//         photoSize: 100.0,
//         onClick: () => print("Flutter Egypt"),
//         loaderColor: Colors.red);
//   }
// }

// class AfterSplash extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return new Scaffold(
//       appBar: new AppBar(
//           title: new Text("Welcome In SplashScreen Package"),
//           automaticallyImplyLeading: false),
//       body: new Center(
//         child: new Text(
//           "Done!",
//           style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0),
//         ),
//       ),
//     );
//   }
// }

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
        HomePage.route: (context) => HomePage(),
        LiveGeolocatorPage.route: (context) => LiveGeolocatorPage(),
        SplashPage.route: (context) => SplashPage(),
        RegisterPage.route: (context) => RegisterPage(),
        LoginPage.route: (context) => LoginPage(),
        MobilePage.route: (context) => MobilePage(),
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
