import 'dart:async';

import 'package:contact_tracing/services/globals.dart';
import 'package:contact_tracing/services/notification.dart';
import 'package:splashscreen/splashscreen.dart';

import 'Location/live_geolocator.dart';
import 'Notification/notifications.dart';
import 'package:flutter/material.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'Login/login.dart';
import 'Mobile/mobiles.dart';
import 'Profile/profile.dart';
import 'Profile/updateDate.dart';

class SplashPage extends StatefulWidget {
  static const String route = '/splash';

  @override
  _SplashPageState createState() {
    print("in splash");
    return _SplashPageState();
  }
}

class _SplashPageState extends State<SplashPage> {
  int _latestUpdate = 0;
  //Writefile _wf = new Writefile();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    NotificationServices().initialize(context);

    ///gives you the message on which user taps
    ///and it opened the app from terminated state
    // FirebaseMessaging.instance.getInitialMessage().then((message) {
    //   if (message != null) {
    //     final routeFromMessage = message.data["route"];
    //     Navigator.of(context).pushNamed(routeFromMessage);
    //   }
    // });

    ///forground work
    // FirebaseMessaging.onMessage.listen((message) {
    //   print(message.notification.body);
    //   print(message.notification.title);

    //   Notif().display(message);
    // });

    ///When the app is in background but opened and user taps
    ///on the notification
    // FirebaseMessaging.onMessageOpenedApp.listen((message) {
    //   final routeFromMessage = message.data["route"];

    //   Navigator.of(context).pushNamed(routeFromMessage);
    // });
  }

  Future<Widget> loadFromFuture() async {
    await Future.delayed(const Duration(seconds: 2), () {});

    // final SharedPreferences prefs = await SharedPreferences.getInstance();
    // if (prefs.getString('latestUpdate') != null) {
    //   try {
    //     if (mounted) {
    //       setState(() {
    //         _latestUpdate =
    //             int.parse(prefs.getString('latestUpdate') as String);
    //       });
    //     }
    //   } catch (e) {
    //     if (mounted) {
    //       setState(() {
    //         _latestUpdate = 0;
    //       });
    //     }
    //   }
    // }

    // try {
    //   var today = DateTime.now();
    //   var nowMinus5days = today.subtract(const Duration(days: 5));
    //   var nowMinus5daysInEpoch =
    //       (nowMinus5days.millisecondsSinceEpoch).toString();
    //   nowMinus5daysInEpoch =
    //       nowMinus5daysInEpoch.substring(0, nowMinus5daysInEpoch.length - 3);
    //   int nowMinus5 = int.parse(nowMinus5daysInEpoch);
    //   if (_latestUpdate < nowMinus5) {
    //     //await _showRestartDialog();
    //   }
    // } catch (exception) {
    //   print(exception);
    // }

    final email = await GlobalVariables.getEmail();
    final mobileNumber = await GlobalVariables.getMobileNumber();

    return Future.value(ProfilePage());
    if (email != null && mobileNumber != null) {
      print("LiveGeolocatorPage");
      return Future.value(LiveGeolocatorPage());
    } else if (email != null) {
      print("MobilePage");
      return Future.value(MobilePage());
    } else {
      print("LoginPage");
      return Future.value(LoginPage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
        navigateAfterFuture: loadFromFuture(),
        title: new Text(
          'Loading...',
          style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
        ),
        image: new Image.network('https://i.imgur.com/TyCSG9A.png'),
        backgroundColor: Colors.white,
        styleTextUnderTheLoader: new TextStyle(),
        photoSize: 100.0,
        onClick: () => print("Flutter Egypt"),
        loaderColor: Colors.red);
  }

  // @override
  // void dispose() {
  //   super.dispose();
  // }
}
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
