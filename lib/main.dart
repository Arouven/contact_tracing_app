import 'dart:async';
import 'package:contact_tracing/services/badgeservices.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'models/pushnotification.dart';
import 'pages/Location/live_geolocator.dart';

import 'pages/Login/login.dart';
import './pages/splash.dart';
import 'pages/Mobile/mobiles.dart';
import 'pages/Notification/notifications.dart';
import 'pages/Profile/profile.dart';
import 'services/globals.dart';
import 'services/notification.dart';
import 'services/uploadClass.dart';
import 'services/write.dart';

Writefile _wf = new Writefile();

void onStart() {
  WidgetsFlutterBinding.ensureInitialized();
  int counter = 0;
  late Timer myTimer;
  final service = FlutterBackgroundService();
  service.onDataReceived.listen((event) {
    if (event!["action"] == "setAsBackground") {
      print("event action == setAsBackground");
      service.setForegroundMode(false);
    }

    if (event["action"] == "stopService") {
      print("event action == stopService");
      myTimer.cancel();
      service.stopBackgroundService();
    }

    if (event["action"] == "startService") {
      print("event = startService and start timer too");
      // bring to foreground
      service.setForegroundMode(true);
      myTimer = Timer.periodic(
        Duration(minutes: timeToGetLocationPerMinute),
        (timer) async {
          print("in timer");
          if (!(await service.isServiceRunning())) {
            print("cancel timer");
            timer.cancel();
            myTimer.cancel();
          }
          Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: geolocatorAccuracy,
          );
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          if ((prefs.getString("email") != null) &&
              (prefs.getString("mobileId") != null)) {
            print("email and mobileid not null at start of service");
            _wf.writeToFile(
              '${position.latitude.toString()}',
              '${position.longitude.toString()}',
              '${position.accuracy.toString()}',
            );
            if (counter > timeToUploadPerMinute) {
              UploadFile uploadFile = new UploadFile();
              uploadFile.uploadToServer();
              print("file uploaded and counter set to 0");
              counter = 0;
            }

            service.setNotificationInfo(
              title: "Contact tracing",
              content:
                  "Updated at ${DateTime.now()} \nLatitude: ${position.latitude.toString()} \nLongitude: ${position.longitude.toString()}",
            );
          } else {
            timer.cancel();
            myTimer.cancel();
          }
          counter = counter + 1;
        },
      );
    }
  });
}

Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}

/// Initialize the [FlutterLocalNotificationsPlugin] package.
late FlutterLocalNotificationsPlugin flutterLNP;
late AndroidNotificationChannel channel;
late NotificationSettings settings;
late FirebaseMessaging _messaging;

Future<void> setFirebase() async {
  channel = NotificationServices().androidNotificationChannel();
  flutterLNP = FlutterLocalNotificationsPlugin();
  await flutterLNP
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  await Firebase.initializeApp();
  _messaging = FirebaseMessaging.instance;

  // 3. On iOS, this helps to take the user permissions
  settings = await _messaging.requestPermission(
    alert: true,
    badge: true,
    provisional: false,
    sound: true,
  );
}

void openAppMessage() {
  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Parse the message received
      sendMsg(message);
    });
  } else {
    print('User declined or has not accepted permission');
  }
}

Future<void> messageHandler(RemoteMessage message) async {
  print('background message ${message.notification!.body}');
  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');
    // Parse the message received
    sendMsg(message);
  } else {
    print('User declined or has not accepted permission');
  }
}

Future<void> sendMsg(RemoteMessage message) async {
  //Notif.notifications.insert(0, message);
  await BadgeServices.updateBadge();
  PushNotification notification = PushNotification(
    title: message.notification?.title,
    body: message.notification?.body,
  );
  NotificationDetails notificationDetails =
      await NotificationServices().getPlatform();
  flutterLNP.show(
    notification.hashCode,
    notification.title,
    notification.body,
    notificationDetails,
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Geolocator.requestPermission();
  Position position = await _determinePosition();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setDouble("lastlat", position.latitude);
  await prefs.setDouble("lastlng", position.longitude);

  await setFirebase();
  openAppMessage();

  FirebaseMessaging.onBackgroundMessage(messageHandler);
  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    print('Message clicked!');
  });
  FlutterBackgroundService.initialize(onStart);
  await BadgeServices.updateBadge();
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
      home: SplashPage(),
      routes: <String, WidgetBuilder>{
        //HomePage.route: (context) => HomePage(),
        LiveGeolocatorPage.route: (context) => LiveGeolocatorPage(),
        SplashPage.route: (context) => SplashPage(),
        //  RegisterPage.route: (context) => RegisterPage(),
        LoginPage.route: (context) => LoginPage(),
        MobilePage.route: (context) => MobilePage(),
        //  AddMobilePage.route: (context) => AddMobilePage(),
        //  UpdateMobilePage.route: (context) => UpdateMobilePage(),
        //  FilterPage.route: (context) => FilterPage(),
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
////////////////////////////////////////////////////
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class PushNotification {
//   PushNotification({
//     this.title,
//     this.body,
//   });
//   String? title;
//   String? body;
// }

// /// Initialize the [FlutterLocalNotificationsPlugin] package.
// late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
// late AndroidNotificationChannel channel;
// late NotificationSettings settings;
// late FirebaseMessaging _messaging;

// Future<void> setFirebase() async {
//   channel = const AndroidNotificationChannel(
//     'high_importance_channel', // id
//     'High Importance Notifications', // title
//     description:
//         'This channel is used for important notifications.', // description
//     importance: Importance.high,
//   );
//   flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//   await flutterLocalNotificationsPlugin
//       .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin>()
//       ?.createNotificationChannel(channel);
//   await Firebase.initializeApp();
//   _messaging = FirebaseMessaging.instance;

//   // 3. On iOS, this helps to take the user permissions
//   settings = await _messaging.requestPermission(
//     alert: true,
//     badge: true,
//     provisional: false,
//     sound: true,
//   );
// }

// void openAppMessage() {
//   if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//     print('User granted permission');
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       // Parse the message received
//       sendMsg(message);
//     });
//   } else {
//     print('User declined or has not accepted permission');
//   }
// }

// Future<void> _messageHandler(RemoteMessage message) async {
//   print('background message ${message.notification!.body}');
//   if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//     print('User granted permission');
//     // Parse the message received
//     sendMsg(message);
//   } else {
//     print('User declined or has not accepted permission');
//   }
// }

// void sendMsg(RemoteMessage message) {
//   PushNotification notification = PushNotification(
//     title: message.notification?.title,
//     body: message.notification?.body,
//   );

//   flutterLocalNotificationsPlugin.show(
//     notification.hashCode,
//     notification.title,
//     notification.body,
//     NotificationDetails(
//       android: AndroidNotificationDetails(
//         'id',
//         'channel.name',
//         channelDescription: 'channel.description',
//         // TODO add a proper drawable resource to android, for now using
//         //      one that already exists in example app.
//         icon: '@mipmap/ic_launcher',
//       ),
//     ),
//   );
// }

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await setFirebase();
//   openAppMessage();
//   FirebaseMessaging.onBackgroundMessage(_messageHandler);
//   FirebaseMessaging.onMessageOpenedApp.listen((message) {
//     print('Message clicked!');
//   });
//   runApp(MyHomePage());
// }

// class MyHomePage extends StatefulWidget {
//   @override
//   GeeksForGeeksState createState() => GeeksForGeeksState();
// }

// class GeeksForGeeksState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Center(child: Text('Hello World')),
//     );
//   }
// }
