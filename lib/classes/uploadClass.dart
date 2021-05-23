import 'dart:io';

import 'package:ftpconnect/ftpconnect.dart';
import '../credentials/credentials.dart';

class UploadFile {
  String fileToUpload;
  String directoryToUpload = '/htdocs/csv/csvFiles/';

  void uploadToServer() async {
    FTPConnect ftpConnect =
        FTPConnect(ftpServer, user: ftpUser, pass: ftpPassword);
    try {
      String time = (new DateTime.now().microsecondsSinceEpoch).toString();
      File fileToUpload = File('${time}_${this.fileToUpload}');
      await ftpConnect.connect();
      await ftpConnect.changeDirectory(this.directoryToUpload);
      await ftpConnect.uploadFile(fileToUpload);
      File fileToDelete = File(this.fileToUpload);
      await fileToDelete.delete();

      print('file uploaded and deleted locally');
    } catch (e) {
      print('Error: ${e.toString()}');
    } finally {
      await ftpConnect.disconnect();
    }
  }
}
