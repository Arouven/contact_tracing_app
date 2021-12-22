import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'globals.dart';

class NotificationServices {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final priority = Priority.high;
  final importance = Importance.max;

  void initialize({required BuildContext context}) {
    print("in Notif");
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: AndroidInitializationSettings(flutterIcon));

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? route) async {
      if (route != null) {
        Navigator.of(context).pushNamed(route);
      }
    });
  }

  AndroidNotificationChannel androidNotificationChannel() {
    return const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.high,
    );
  }

  Future<NotificationDetails> getPlatform() async {
    print("in Notif");
    var android = new AndroidInitializationSettings(flutterIcon);
    var iOS = new IOSInitializationSettings();
    var initializationSettings =
        new InitializationSettings(android: android, iOS: iOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      importance: importance,
      priority: priority,
    );
    final IOSNotificationDetails iOSNotificationDetails =
        IOSNotificationDetails();

    final NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSNotificationDetails,
    );
    return platformChannelSpecifics;
  }

  // void display(RemoteMessage message) async {
  //   try {
  //     final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
  //     final platformChannelSpecifics = await getPlatform();
  //     await flutterLocalNotificationsPlugin.show(
  //       id,
  //       message.notification.title,
  //       message.notification.body,
  //       platformChannelSpecifics,
  //       payload: message.data["route"],
  //     );
  //   } on Exception catch (e) {
  //     print(e);
  //   }
  // }

  Future<void> showNotification({
    required String notificationTitle,
    required String notificationBody,
  }) async {
    print("in Notif");
    final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final platformChannelSpecifics = await getPlatform();
    await flutterLocalNotificationsPlugin.show(
      id,
      notificationTitle,
      notificationBody,
      platformChannelSpecifics,
    );
    print('notified');
  }
}
