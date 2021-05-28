import 'dart:io';

import 'package:contact_tracing/classes/notification.dart';
import 'package:ftpconnect/ftpconnect.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../credentials/credentials.dart';
import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class UploadFile {
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
      print('file deleted');

      await Notif().showNotification('File Uploaded',
          '${time}_${prefs.getString("fileName")} was uploaded');
      // await notification.showNotification('File Uploaded',
      //     '${time}_${prefs.getString("fileName")} was uploaded');
    } catch (e) {
      print('Error: ${e.toString()}');
    } finally {
      await ftpConnect.disconnect();
    }
  }
}
