import 'dart:io';

import 'package:ftpconnect/ftpconnect.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../credentials/credentials.dart';
import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class UploadFile {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  //String fileToUpload;
  final String directoryToUpload = '/htdocs/csv/csvFiles/';

  void uploadToServer() async {
    FTPConnect ftpConnect =
        FTPConnect(ftpServer, user: ftpUser, pass: ftpPassword);

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String currentFilePath =
          prefs.getString("fileDirectory") + prefs.getString("fileName");
      File file = File(currentFilePath);
      String time = (new DateTime.now().microsecondsSinceEpoch).toString();
      String renamedFilePath =
          '${prefs.getString("fileDirectory")}${time}_${prefs.getString("fileName")}';
      await file.rename(renamedFilePath);

      File renamedFile = File(renamedFilePath);
      await ftpConnect.connect();
      await ftpConnect.changeDirectory(this.directoryToUpload);
      await ftpConnect.uploadFile(renamedFile);
      await renamedFile.delete();

      var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
      var iOS = new IOSInitializationSettings();
      var initializationSettings =
          new InitializationSettings(android: android, iOS: iOS);
      await flutterLocalNotificationsPlugin.initialize(initializationSettings);

      await _showNotificationCustomSound('File Uploaded',
          '${time}_${prefs.getString("fileName")} was uploaded');
    } catch (e) {
      print('Error: ${e.toString()}');
    } finally {
      await ftpConnect.disconnect();
    }
  }

  Future<void> _showNotificationCustomSound(
      String notificationTitle, String notificationBody) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'your channel id', 'your channel name', 'your channel description',
            importance: Importance.max, priority: Priority.high);
    const IOSNotificationDetails iOSNotificationDetails =
        IOSNotificationDetails();

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iOSNotificationDetails);

    await flutterLocalNotificationsPlugin.show(
        0, notificationTitle, notificationBody, platformChannelSpecifics);
  }
}
