// import 'package:shared_preferences/shared_preferences.dart';

// class Badgeservices {
//   static String badgeText = '';

//   Badgeservices() {
//     updateText();
//   }
//   updateText() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     if (prefs.getString('badge') != null) {
//       final badgeNumber = prefs.getString('badge') as String;
//       badgeText = badgeNumber;
//     } else {
//       badgeText = '';
//     }
//   }
// }
import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Badges {
  static int number = 0;

  static Widget ss() {
    if (number > 0) {
      print(number);
      return (Badge(
        badgeContent: Text(
          number.toString(),
          style: TextStyle(fontSize: 8.0),
        ),
        child: Icon(Icons.notifications),
      ));
    } else {
      return (Icon(Icons.notifications));
    }
  }
}
