import 'dart:async';

import '../pages/live_geolocator.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splashscreen/splashscreen.dart';

import '../pages/login.dart';
import '../pages/mobiles.dart';

class SplashPage extends StatefulWidget {
  static const String route = '/splash';

  @override
  _SplashPageState createState() {
    return _SplashPageState();
  }
}

class _SplashPageState extends State<SplashPage> {
  Future<Widget> loadFromFuture() async {
    await Future.delayed(const Duration(seconds: 2), () {});
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.setString('username', 'Johny');
    // await prefs.setString('password', '1234');
    // await prefs.setString("mobileId", '8');
    if (prefs.getString('username') != null &&
        prefs.getString('password') != null &&
        prefs.getString("mobileId") != null) {
      var fn =
          '${prefs.getString("mobileId")}_${prefs.getString("username")}_geolocatorbest.csv';
      await prefs.setString("fileName", fn);
      return Future.value(LiveGeolocatorPage());
    } else if (prefs.getString('username') != null &&
        prefs.getString('password') != null &&
        prefs.getString("mobileId") == null) {
      return Future.value(MobilePage());
    }
    //Get.to(LoginnPage());
    return Future.value(LoginPage());
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
