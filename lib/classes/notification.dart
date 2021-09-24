import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'globals.dart';

class Notif {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final priority = Priority.high;
  final importance = Importance.max;

  void initialize(BuildContext context) {
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: AndroidInitializationSettings(flutterIcon));

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String route) async {
      if (route != null) {
        Navigator.of(context).pushNamed(route);
      }
    });
  }

  Future<NotificationDetails> getPlatform() async {
    var android = new AndroidInitializationSettings(flutterIcon);
    var iOS = new IOSInitializationSettings();
    var initializationSettings =
        new InitializationSettings(android: android, iOS: iOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(channelId, channelName, channelDescription,
            importance: importance, priority: priority);
    final IOSNotificationDetails iOSNotificationDetails =
        IOSNotificationDetails();

    final NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iOSNotificationDetails);
    return platformChannelSpecifics;
  }

  void display(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch;
      final platformChannelSpecifics = await getPlatform();
      await flutterLocalNotificationsPlugin.show(
        id,
        message.notification.title,
        message.notification.body,
        platformChannelSpecifics,
        payload: message.data["route"],
      );
    } on Exception catch (e) {
      print(e);
    }
  }

  Future<void> showNotification(
      String notificationTitle, String notificationBody) async {
    final id = DateTime.now().millisecondsSinceEpoch;
    final platformChannelSpecifics = await getPlatform();
    await flutterLocalNotificationsPlugin.show(
        id, notificationTitle, notificationBody, platformChannelSpecifics);

    print('notified');
  }
}
