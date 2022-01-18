import 'package:contact_tracing/main.dart';
import 'package:contact_tracing/services/globals.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';

class BadgeServices {
  //static int number = 0;

  // Widget notificationBadge() {
  //   if (number > 0) {
  //     print(number);
  //     return (Badge(
  //       badgeContent: Text(
  //         number.toString(),
  //         style: TextStyle(fontSize: 8.0),
  //       ),
  //       child: Icon(Icons.notifications),
  //     ));
  //   } else {
  //     return (Icon(Icons.notifications));
  //   }
  // }

  static updateBadge() async {
    try {
      await updateNotificationBadge();
    } finally {
      await updateAppBadge();
    }
  }

  static updateNotificationBadge() async {
    if (path != "") {
      DatabaseReference ref = FirebaseDatabase.instance.ref(path);
      // Get the data once
      DatabaseEvent event = await ref.once();

// Print the data of the snapshot
      print('values: ' + event.snapshot.value.toString()); // { "name": "John" }
      DataSnapshot snapshot = event.snapshot; // DataSnapshot
      Map message = snapshot.value as Map;

      int badge = 0;
      if (message != null) {
        message.forEach((key, value) {
          bool read = value['read'] as bool;
          if (read == false) {
            badge = badge + 1;
          }
        });
      }
      await GlobalVariables.setBadgeNumber(badgeNumber: badge);
      // number = badge;
    }
  }

  static updateAppBadge() async {
    ((await GlobalVariables.getBadgeNumber()) > 0)
        ? FlutterAppBadger.updateBadgeCount(
            await GlobalVariables.getBadgeNumber())
        : FlutterAppBadger.removeBadge();
    // if (number > 0) {
    //   FlutterAppBadger.updateBadgeCount(number);
    // } else {
    //   FlutterAppBadger.removeBadge();
    // }
  }
}
