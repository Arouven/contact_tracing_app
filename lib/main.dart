import 'dart:async';
// import 'package:contact_tracing/pages/Location/filter.dart';
// import 'package:contact_tracing/pages/Mobile/updateMobile.dart';
import 'package:contact_tracing/classes/notification.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

import 'models/pushnotification.dart';
import 'pages/Location/live_geolocator.dart';
// import 'pages/Mobile/addMobile.dart';
import './classes/globals.dart';
import './classes/uploadClass.dart';
import './classes/write.dart';
// import 'pages/Login/register.dart';
import 'pages/Login/login.dart';
import './pages/splash.dart';
import 'pages/Mobile/mobiles.dart';
import 'pages/Notification/notifications.dart';
import 'pages/Profile/profile.dart';

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
          if ((prefs.getString("username") != null) &&
              (prefs.getString("mobileId") != null)) {
            print("username and mobileid not null at start of service");
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
          // service.sendData(
          //   {"current_date": DateTime.now().toIso8601String()},
          // );
          counter = counter + 1;
        },
      );
    }
  });
}

/// Initialize the [FlutterLocalNotificationsPlugin] package.
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
late AndroidNotificationChannel channel;
late NotificationSettings settings;
late FirebaseMessaging _messaging;

Future<void> setFirebase() async {
  channel = Notif().androidNotificationChannel();
  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin
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

Future<void> _messageHandler(RemoteMessage message) async {
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
  PushNotification notification = PushNotification(
    title: message.notification?.title,
    body: message.notification?.body,
  );
  NotificationDetails notificationDetails = await Notif().getPlatform();
  flutterLocalNotificationsPlugin.show(
    notification.hashCode,
    notification.title,
    notification.body,
    notificationDetails,
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Geolocator.requestPermission();
  await setFirebase();
  openAppMessage();
  FirebaseMessaging.onBackgroundMessage(_messageHandler);
  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    print('Message clicked!');
  });
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
