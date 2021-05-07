import 'dart:io';

import 'package:ftpconnect/ftpconnect.dart';
import '../credentials/credentials.dart';

class uploadFile {
  var fileToUpload;
  var directoryToUpload;

  uploadFile() {
    //Point(double x, double y)
    this.fileToUpload = 'fileToUpload.txt';
    this.directoryToUpload = '/htdocs/csv/csvFiles';
  }

  uploadToServer() async {
    FTPConnect ftpConnect =
        FTPConnect(ftpServer, user: ftpUser, pass: ftpPassword);
    try {
      File fileToUpload = File(this.fileToUpload);
      await ftpConnect.connect();
      await ftpConnect.changeDirectory(this.directoryToUpload);
      await ftpConnect.uploadFile(fileToUpload);
      print('file uploaded');
    } catch (e) {
      print('Error: ${e.toString()}');
    } finally {
      await ftpConnect.disconnect();
    }
  }
}
