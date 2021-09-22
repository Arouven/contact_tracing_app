import 'dart:async';

import 'Location/live_geolocator.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splashscreen/splashscreen.dart';

import 'Login/login.dart';
import 'Mobile/mobiles.dart';
//import 'package:flutter_restart/flutter_restart.dart';

class SplashPage extends StatefulWidget {
  static const String route = '/splash';

  @override
  _SplashPageState createState() {
    return _SplashPageState();
  }
}

class _SplashPageState extends State<SplashPage> {
  int _latestUpdate = 0;
  // Future<void> _showRestartDialog() async {
  //   return showDialog<void>(
  //     context: context,
  //     barrierDismissible: false, // user must tap button!
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text(
  //           'Restart',
  //           style: TextStyle(color: Colors.green),
  //         ),
  //         content: SingleChildScrollView(
  //           child: ListBody(
  //             children: <Widget>[
  //               new Row(
  //                 children: [
  //                   Expanded(
  //                     child: Text(
  //                         'The app needs to be restarted because it has not gather coordinates in a while. Press OK to restart.'),
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ),
  //         actions: <Widget>[
  //           TextButton(
  //             child: const Text('Ok'),
  //             onPressed: () async {
  //               FlutterRestart.restartApp();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
  deleteme() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', 'JamesSmith');
    await prefs.setString('password', '1234');
    await prefs.setString("mobileId", '1');
  }

  Future<Widget> loadFromFuture() async {
    await Future.delayed(const Duration(seconds: 2), () {});
    await deleteme();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('latestUpdate') != null) {
      try {
        if (mounted) {
          setState(() {
            _latestUpdate = int.parse(prefs.getString('latestUpdate'));
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _latestUpdate = 0;
          });
        }
      }
    }

    try {
      var today = DateTime.now();
      var nowMinus5days = today.subtract(const Duration(days: 5));
      var nowMinus5daysInEpoch =
          (nowMinus5days.millisecondsSinceEpoch).toString();
      nowMinus5daysInEpoch =
          nowMinus5daysInEpoch.substring(0, nowMinus5daysInEpoch.length - 3);
      int nowMinus5 = int.parse(nowMinus5daysInEpoch);
      if (_latestUpdate < nowMinus5) {
        //await _showRestartDialog();
      }
    } catch (exception) {
      print(exception);
    }

    if (prefs.getString('username') != null &&
        prefs.getString('password') != null &&
        prefs.getString("mobileId") != null) {
      var fn = '${prefs.getString("username")}_geolocatorbest.csv';
      await prefs.setString("fileName", fn);
      return Future.value(LiveGeolocatorPage());
    } else if (prefs.getString('username') != null &&
        prefs.getString('password') != null &&
        prefs.getString("mobileId") == null) {
      return Future.value(MobilePage());
    } else {
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
