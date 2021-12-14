import 'package:badges/badges.dart';
import 'package:contact_tracing/pages/Notification/notifications.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';

class BadgeServices {
  static int number = 0;

  static Widget notificationBadge() {
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

  static updateBadge() async {
    await updateNotificationBadge();
    updateAppBadge();
  }

  static updateNotificationBadge() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(path);
    // Get the data once
    DatabaseEvent event = await ref.once();

// Print the data of the snapshot
    print('values: ' + event.snapshot.value.toString()); // { "name": "John" }
    DataSnapshot snapshot = event.snapshot; // DataSnapshot
    Map message = snapshot.value as Map;

    int badge = 0;
    message.forEach((key, value) {
      bool read = value['read'] as bool;
      if (read == false) {
        badge = badge + 1;
      }
      // print(badge);
    });
    number = badge;
  }

  static updateAppBadge() {
    if (number > 0) {
      FlutterAppBadger.updateBadgeCount(number);
    } else {
      FlutterAppBadger.removeBadge();
    }
  }
}
