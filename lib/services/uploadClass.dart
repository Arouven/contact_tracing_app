import 'dart:io';
import 'package:ftpconnect/ftpconnect.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'globals.dart';
import 'notification.dart';

class UploadFile {
  //String fileToUpload;
  final String directoryToUpload = '/public_html/csv_to_sql/csvFiles/';

  void uploadToServer() async {
    print("in UploadFile");
    FTPConnect ftpConnect =
        FTPConnect(ftpServer, user: ftpUser, pass: ftpPassword);

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? currentFilePath = prefs.getString("fileDirectory")! +
          prefs.getString("firebaseuid")! +
          "_geolocatorbest.csv";
      File file = File(currentFilePath);
      String time = (new DateTime.now().millisecondsSinceEpoch).toString();
      time = time.substring(0, time.length - 3);
      String fileName =
          '${time}_${prefs.getString("firebaseuid")}_geolocatorbest.csv';
      String renamedFilePath = '${prefs.getString("fileDirectory")}$fileName';
      await file.rename(renamedFilePath);

      File renamedFile = File(renamedFilePath);
      await ftpConnect.connect();
      await ftpConnect.changeDirectory(this.directoryToUpload);
      await ftpConnect.uploadFile(renamedFile);
      await renamedFile.delete();
      print('$fileName file deleted');

      await NotificationServices()
          .showNotification('File Uploaded', '$fileName was uploaded');
    } catch (e) {
      print('Error: ${e.toString()}');
    } finally {
      await ftpConnect.disconnect();
    }
  }
}
