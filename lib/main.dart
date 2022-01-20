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
import 'package:contact_tracing/services/auth.dart';
import 'package:contact_tracing/services/badgeservices.dart';
import 'package:contact_tracing/services/databaseServices.dart';
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
//late FlutterLocalNotificationsPlugin flutterLNP;
//late AndroidNotificationChannel channel;
//late NotificationSettings settings;
//late FirebaseMessaging _messaging;
Widget? _pageSelected;
late var _isDarkMode = null;
late var _badgeNumber = null;
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
      //  return;
    }

    if (event["action"] == "stopService") {
      print("event action == stopService");
      service.stopBackgroundService();
    }
  });
  // bring to foreground
  // service.setForegroundMode(true);
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
        if ((await GlobalVariables.getNotifier()) != false) {
          service.setNotificationInfo(
            title: "Contact tracing",
            content:
                "Updated at ${DateTime.now()} \nLatitude: ${position.latitude.toString()} \nLongitude: ${position.longitude.toString()}",
          );
        }
        counter = counter + 1;
      }
    },
  );
}

// Future<void> _setFirebase() async {

//   //await Firebase.initializeApp();
//   // _messaging =FirebaseMessaging.instance ;

//   // 3. On iOS, this helps to take the user permissions
//   // settings = await FirebaseMessaging.instance.requestPermission(
//   //   alert: true,
//   //   badge: true,
//   //   provisional: false,
//   //   sound: true,
//   // );
// }

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
  try {
    print('background message ${message.notification!.body}');

    int badgenumber = await GlobalVariables.getBadgeNumber();
    badgenumber += 1;
    await GlobalVariables.setBadgeNumber(badgeNumber: badgenumber);

    await BadgeServices.updateAppBadge();
    PushNotification notification = PushNotification(
      title: message.notification?.title,
      body: message.notification?.body,
    );
    NotificationDetails notificationDetails =
        await NotificationServices().getPlatform();
    var flutterLNP = FlutterLocalNotificationsPlugin();
    var channel = NotificationServices().androidNotificationChannel();
    await flutterLNP
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    flutterLNP.show(
      notification.hashCode,
      notification.title,
      notification.body,
      notificationDetails,
    );
  } catch (e) {
    print('error in firebase messabing');
    print(e);
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

    // _listenToDbNotif();

    // var isRunning = await service.isServiceRunning();
    // print("is running using backagound returns $isRunning");
    // print('is running ' + isRunning.toString());
    //  if (isRunning == false) { //if (!(await service.isServiceRunning())) {print("cancel timer");timer.cancel();}
    bool s = (await GlobalVariables.getService());
    print(s);
    if ((await GlobalVariables.getService()) != true) {
      await GlobalVariables.setService(service: true);
      //either null or false
      print('start the service');
      FlutterBackgroundService.initialize(onStart);
      final title = 'Services Started';
      final body = 'You are now connected to our app';
      String time = (new DateTime.now().millisecondsSinceEpoch).toString();
      time = time.substring(0, time.length - 3);
      int timestamp = int.parse(time);
      if (path != "") {
        DatabaseReference ref = FirebaseDatabase.instance.ref(path);
        final data = <String, dynamic>{
          "body": body,
          "read": false,
          "timestamp": timestamp,
          "title": title,
        };
        await ref.push().set(data);
        print("check your database");
      }
      print('in return');
      //return;
    }
    //  }
  }
}

// Future<void> _updateFirebaseNotification({
//   required String notificationTitle,
//   required String notificationBody,
// }) async {}

Future logout(context) async {
  await GlobalVariables.unsetAll();
  FlutterBackgroundService().sendData({"action": "stopService"});
  Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
      (route) => false);
}

Future _pageSelector() async {
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
          if (json['read'] == false) {
            await NotificationServices().showNotification(
              notificationTitle: json['title'],
              notificationBody: json['body'],
            );
          }
        }
      } catch (e) {
        print(e);
      }
    });
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // _pageSelected = UpdateMobilePage(
  //   mobile: Mobile(
  //     mobileNumber: '+23057775794',
  //     mobileName: 'my mobile',
  //     email: 'apoolian@umail.utm.ac.mu',
  //     fcmtoken: 'dummy token',
  //   ),
  // );
  try {
    _isDarkMode = await GlobalVariables.getDarkTheme();
    _badgeNumber = await GlobalVariables.getBadgeNumber();
  } catch (e) {
    print(e.toString());
    _badgeNumber = null;
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
    //await _setFirebase();
    // _openAppMessage();
    await GlobalVariables.setEmail(email: 'apoolian@umail.utm.ac.mu');
    await GlobalVariables.setMobileNumber(mobileNumber: '+23057775794');
    await generatePath();
    final mobileNumber = await GlobalVariables.getMobileNumber();
    final fcmtoken = await FirebaseAuthenticate().getfirebasefcmtoken();
    if (fcmtoken != null) {
      await DatabaseMySQLServices.updateMobilefmcToken(
        mobileNumber: mobileNumber,
        fcmtoken: fcmtoken,
      );
    }
    await startServices();
    _pageSelected =
        await _pageSelector(); // NotificationsPage(); //await _pageSelector();
    FirebaseMessaging.onBackgroundMessage(_messageHandler);
    // FirebaseMessaging.onMessageOpenedApp.listen((message) {
    //   print('Message clicked!');
    // });
    await BadgeServices.updateBadge();

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
