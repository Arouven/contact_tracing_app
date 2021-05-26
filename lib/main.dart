import 'package:contact_tracing/classes/background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import './pages/live_geolocator.dart';
import 'dart:async';

const taskPushFtpServer = 'taskPushFtpServer';
void callbackDispatcher() {
  Workmanager().executeTask(
    (task, inputData) async {
      // await ;
      switch (task) {
        case taskPushFtpServer:
          Background().taskPushFtpServer();
          break;
      }
      return Future.value(true);
    },
  );
}

void onStart() {
  WidgetsFlutterBinding.ensureInitialized();
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
  Timer.periodic(Duration(seconds: 1), (timer) async {
    if (!(await service.isServiceRunning())) timer.cancel();
    service.setNotificationInfo(
      title: "Contact tracing",
      content: "Updated at ${DateTime.now()} \n L",
    );

    service.sendData(
      {"current_date": DateTime.now().toIso8601String()},
    );
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString("nationalIdNumber", "P61548465161654816");
  await prefs.setString("mobileID", "100");
  var fn =
      '${prefs.getString("mobileID")}_${prefs.getString("nationalIdNumber")}_geolocatorbest.csv';
  await prefs.setString("fileName", fn);
  _wf = new Writefile();
  FlutterBackgroundService.initialize(onStart);
  Workmanager().initialize(
    callbackDispatcher,
  );
  Workmanager().registerPeriodicTask(
    '1',
    taskPushFtpServer,
    frequency: Duration(hours: 6),
  );
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
      home: LiveGeolocatorPage(), //HomePage(),
      // routes: <String, WidgetBuilder>{
      //   LiveGeolocatorPage.route: (context) => LiveGeolocatorPage(),
      // },
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
