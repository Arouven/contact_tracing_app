import 'dart:async';
import 'package:contact_tracing/models/pushnotification.dart';
import 'package:contact_tracing/pages/Location/live_geolocator.dart';
import 'package:contact_tracing/pages/Login/login.dart';
import 'package:contact_tracing/pages/Mobile/mobiles.dart';
import 'package:contact_tracing/pages/Notification/notifications.dart';
import 'package:contact_tracing/pages/Profile/profile.dart';
import 'package:contact_tracing/pages/Setting/setting.dart';
import 'package:contact_tracing/providers/notificationbadgemanager.dart';
import 'package:contact_tracing/providers/thememanager.dart';
import 'package:contact_tracing/services/badgeservices.dart';
import 'package:contact_tracing/services/globals.dart';
import 'package:contact_tracing/services/notification.dart';
import 'package:contact_tracing/services/uploadClass.dart';
import 'package:contact_tracing/services/write.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Writefile _wf = new Writefile();

/// Initialize the [FlutterLocalNotificationsPlugin] package.
late FlutterLocalNotificationsPlugin flutterLNP;
late AndroidNotificationChannel channel;
late NotificationSettings settings;
//late FirebaseMessaging _messaging;
Widget? _pageSelected;
late var _isDarkMode = null;
late String path = ""; //"notification/+23057775794/"; // "";

Future<void> generatePath() async {
  final phoneNumber = await GlobalVariables.getMobileNumber();
  if (phoneNumber != null) {
    path = "notification/$phoneNumber/";
  }
  //
  //path = "notification/+23057775794/";
}

void onStart() {
  WidgetsFlutterBinding.ensureInitialized();
  int counter = 0;
  // late Timer myTimer;
  final service = FlutterBackgroundService();
  service.onDataReceived.listen((event) async {
    if (event!["action"] == "setAsForeground") {
      print("event = setAsForeground");
      // bring to foreground
      service.setForegroundMode(true);
      await GlobalVariables.setForegroundServices(showServices: true);
      return;
    }
    if (event["action"] == "setAsBackground") {
      print("event action == setAsBackground");
      service.setForegroundMode(false);
      await GlobalVariables.setForegroundServices(showServices: false);
    }

    if (event["action"] == "stopService") {
      print("event action == stopService");
      service.stopBackgroundService();
    }
  });
  // bring to foreground
  service.setForegroundMode(true);
  Timer.periodic(
    Duration(minutes: timeToGetLocationPerMinute),
    (timer) async {
      print("in timer");
      if (!(await service.isServiceRunning())) {
        print("cancel timer");
        timer.cancel();
      }
      final email = await GlobalVariables.getEmail();
      final mobileNumber = await GlobalVariables.getMobileNumber();
      if ((email != null) && (mobileNumber != null)) {
        print("email and mobileid not null at start of service");
        await generatePath();
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: geolocatorAccuracy,
        );
//create file and write to it. if already exist append the file.
        _wf.writeToFile(
          '${position.latitude.toString()}',
          '${position.longitude.toString()}',
          '${position.accuracy.toString()}',
        );
        if (counter > (timeToUploadPerMinute) * 60) {
          await UploadFile.uploadToServer();
          print("file uploaded and counter set to 0");
          counter = 0;
        }
        service.setNotificationInfo(
          title: "Contact tracing",
          content:
              "Updated at ${DateTime.now()} \nLatitude: ${position.latitude.toString()} \nLongitude: ${position.longitude.toString()}",
        );
        counter = counter + 1;
      }
    },
  );
}

Future<void> _setFirebase() async {
  channel = NotificationServices().androidNotificationChannel();
  flutterLNP = FlutterLocalNotificationsPlugin();
  await flutterLNP
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  await Firebase.initializeApp();
  // _messaging =FirebaseMessaging.instance ;

  // 3. On iOS, this helps to take the user permissions
  settings = await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    provisional: false,
    sound: true,
  );
}

// void _openAppMessage() {
//   if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//     print('User granted permission');
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       // Parse the message received

//       _sendMsg(message);
//     });
//   } else {
//     print('User declined or has not accepted permission');
//   }
// }

Future<void> _messageHandler(RemoteMessage message) async {
  print('background message ${message.notification!.body}');
  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');
    // Parse the message received
    //Notif.notifications.insert(0, message);
    // await BadgeServices.updateBadge();
    BadgeServices.number = BadgeServices.number + 1;
    BadgeServices.updateAppBadge();
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
  } else {
    print('User declined or has not accepted permission');
  }
}

Future<void> startServices() async {
  await Geolocator.requestPermission();
  print('start services');
  final email = await GlobalVariables.getEmail();
  final mobileNumber = await GlobalVariables.getMobileNumber();
  if ((email != null) && (mobileNumber != null)) {
    print('email and mobile number not null');
    await generatePath();

    ///   _listenToDbUpdateBadge();

    _listenToDbNotif();
    // var isRunning = await FlutterBackgroundService().isServiceRunning();
    // print('is running ' + isRunning.toString());
    //  if (isRunning == false) { //if (!(await service.isServiceRunning())) {print("cancel timer");timer.cancel();}
    if ((await GlobalVariables.getService()) != true) {
      //either null or false
      print('start the service');
      FlutterBackgroundService.initialize(onStart);
      final title = 'Services Started';
      final body = 'You are now connected to our app';
      await updateFirebaseNotification(
        notificationTitle: title,
        notificationBody: body,
      );
      // await NotificationServices().showNotification(
      //   notificationTitle: title,
      //   notificationBody: body,
      // );
      await GlobalVariables.setService(service: true);
    }
    //  }
  }
}

Future<void> updateFirebaseNotification({
  required String notificationTitle,
  required String notificationBody,
}) async {
  String time = (new DateTime.now().millisecondsSinceEpoch).toString();
  time = time.substring(0, time.length - 3);
  if (path != "") {
    DatabaseReference ref = FirebaseDatabase.instance.ref(path);
    final data = <String, dynamic>{
      "body": notificationBody,
      "read": false,
      "timestamp": time,
      "title": notificationTitle,
    };
    await ref.push().set(data);
    print("check your database");
  }
}

Future logout(context) async {
  await GlobalVariables.unsetAll();
  FlutterBackgroundService().sendData({"action": "stopService"});
  Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
      (route) => false);
}

Future pageSelector() async {
  try {
    final email = await GlobalVariables.getEmail();
    final mobileNumber = await GlobalVariables.getMobileNumber();
    if (email != null && mobileNumber != null) {
      print("LiveGeolocatorPage");
      return LiveGeolocatorPage();
    } else if (email != null) {
      print("MobilePage");
      return MobilePage();
    } else {
      print("LoginPage");
      return LoginPage();
    }
  } catch (e) {
    print(e);
    return LoginPage();
  }
}

void _listenToDbNotif() {
  if (path != "") {
    print('listening for new child from firebase');
    DatabaseReference ref = FirebaseDatabase.instance.ref(path);
// Get the Stream
    Stream<DatabaseEvent> stream = ref.onChildAdded;

// Subscribe to the stream!
    stream.listen((DatabaseEvent event) async {
      try {
        DataSnapshot snapshot = event.snapshot; // DataSnapshot
        print('new child added to list');
        //{timestamp: 1642240673, body: You may be infected practice self-isolation and perform a test, title: In Contact, read: true}
        if (snapshot.value != null) {
          final json = snapshot.value as Map;
          print(json['read']);
          await NotificationServices().showNotification(
            notificationTitle: json['title'],
            notificationBody: json['body'],
          );
        }
      } catch (e) {
        print(e);
      }
    });
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GlobalVariables.setEmail(email: 'apoolian@umail.utm.ac.mu');
  await GlobalVariables.setMobileNumber(mobileNumber: '+23057775794');
  await generatePath();
  try {
    _isDarkMode = await GlobalVariables.getDarkTheme();
  } catch (e) {
    print(e);
    _isDarkMode = null;
  }
  try {
    final bool notif = await GlobalVariables.getNotifier();
    if (notif == null) {
      print('null notif');
      await GlobalVariables.setNotifier(notifier: true);
    }
  } catch (e) {
    print(e);
    await GlobalVariables.setNotifier(notifier: true);
  }
  try {
    _pageSelected = await pageSelector();
    await _setFirebase();
    // _openAppMessage();

    FirebaseMessaging.onBackgroundMessage(_messageHandler);
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('Message clicked!');
    });
    await BadgeServices.updateBadge();

    ///  _listenToDbUpdateBadge();

    _listenToDbNotif();
  } catch (e) {
    print(e);
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<ThemeProvider>(
            create: (context) => new ThemeProvider(),
          ),
          ChangeNotifierProvider<NotificationBadgeProvider>(
            create: (context) => new NotificationBadgeProvider(),
          ),
        ],
        builder: (context, _) {
          final themeProvider = Provider.of<ThemeProvider>(context);
          if (_isDarkMode != null) {
            themeProvider.toggleTheme(_isDarkMode);
          }
          return MaterialApp(
            title: 'Contact tracing',
            theme: lightMode,
            darkTheme: darkMode,
            themeMode: themeProvider.themeMode,
            home: (_pageSelected != null) ? _pageSelected : LoginPage(),
            routes: <String, WidgetBuilder>{
              LiveGeolocatorPage.route: (context) => LiveGeolocatorPage(),
              LoginPage.route: (context) => LoginPage(),
              MobilePage.route: (context) => MobilePage(),
              NotificationsPage.route: (context) => NotificationsPage(),
              ProfilePage.route: (context) => ProfilePage(),
              SettingPage.route: (context) => SettingPage(),
            },
          );
        });
    // return ChangeNotifierProvider<ThemeProvider>(
    //     create: (context) => new ThemeProvider(),

    // return ChangeNotifierProvider<ThemeProvider>(
    //   create: (context) => new ThemeProvider(),
    //   builder: (context, _) {
    //     final themeProvider = Provider.of<ThemeProvider>(context);
    //     if (_isDarkMode != null) {
    //       themeProvider.toggleTheme(_isDarkMode);
    //     }
    //     return MaterialApp(
    //       title: 'Contact tracing',
    //       theme: lightMode,
    //       darkTheme: darkMode,
    //       themeMode: themeProvider.themeMode,
    //       home: (_pageSelected != null) ? _pageSelected : LoginPage(),
    //       routes: <String, WidgetBuilder>{
    //         LiveGeolocatorPage.route: (context) => LiveGeolocatorPage(),
    //         LoginPage.route: (context) => LoginPage(),
    //         MobilePage.route: (context) => MobilePage(),
    //         NotificationsPage.route: (context) => NotificationsPage(),
    //         ProfilePage.route: (context) => ProfilePage(),
    //         SettingPage.route: (context) => SettingPage(),
    //       },
    //     );
    //   },
    // );
  }
}

var darkMode = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.grey,
  // primaryColor: Colors.black,
  // accentColor: Colors.green,
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
    ),
  ),
  // floatingActionButtonTheme: FloatingActionButtonThemeData(
  //   foregroundColor: Colors.black,
  //   backgroundColor: Colors.grey,
  // ),
);

var lightMode = ThemeData.light().copyWith(
  brightness: Brightness.light,
  //primaryColor: Colors.blue,
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
    ),
  ),
);
// final darkMode = ThemeData(
//   primarySwatch: Colors.grey,
//   primaryColor: Colors.black,
//   brightness: Brightness.dark,
//   backgroundColor: const Color(0xFF212121),
//   accentColor: Colors.white,
//   accentIconTheme: IconThemeData(color: Colors.black),
//   dividerColor: Colors.black12,
//   floatingActionButtonTheme: FloatingActionButtonThemeData(
//     foregroundColor: Colors.black,
//     backgroundColor: Colors.grey,
//   ),
// );

// final lightMode = ThemeData(primarySwatch: lightBlueTheme);
// final lightMode = ThemeData(
//   primarySwatch: Colors.lightBlue,
//   primaryColor: Colors.blue,
//   brightness: Brightness.light,
//   backgroundColor: const Color(0xFFE5E5E5),
//   accentColor: Colors.black,
//   accentIconTheme: IconThemeData(color: Colors.white),
//   dividerColor: Colors.white54,
//   floatingActionButtonTheme: FloatingActionButtonThemeData(
//     foregroundColor: Colors.white,
//     backgroundColor: Colors.blue[900],
//   ),
// );

// const MaterialColor lightBlueTheme = MaterialColor(
//   0xFF395afa,
//   <int, Color>{
//     50: Color(0xFFE7EBFE),
//     100: Color(0xFFC4CEFE),
//     200: Color(0xFF9CADFD),
//     300: Color(0xFF748CFC),
//     400: Color(0xFF5773FB),
//     500: Color(0xFF395afa),
//     600: Color(0xFF3352F9),
//     700: Color(0xFF2C48F9),
//     800: Color(0xFF243FF8),
//     900: Color(0xFF172EF6),
//   },
// );
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
