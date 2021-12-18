import 'dart:io';
import 'package:contact_tracing/services/auth.dart';
import 'package:contact_tracing/services/databaseServices.dart';
import 'package:ftpconnect/ftpconnect.dart';

import 'globals.dart';
import 'notification.dart';

class UploadFile {
  void uploadToServer() async {
    print("in UploadFile");
    FTPConnect ftpConnect = FTPConnect(
      ftpServer,
      user: ftpUser,
      pass: ftpPassword,
    );

    try {
      final email = await GlobalVariables.getEmail();
      final fileDirectory = await GlobalVariables.getFileDirectory();
      if (email != null && fileDirectory != null) {
        String currentFilePath = "$fileDirectory${email}_geolocatorbest.csv";
        File file = File(currentFilePath);
        String time = (new DateTime.now().millisecondsSinceEpoch).toString();
        time = time.substring(0, time.length - 3);
        String fileName = '${time}_${email}_geolocatorbest.csv';
        String renamedFilePath = '$fileDirectory$fileName';
        await file.rename(renamedFilePath);

        File renamedFile = File(renamedFilePath);
        await ftpConnect.connect();
        await ftpConnect.changeDirectory(directoryToUpload);
        await ftpConnect.uploadFile(renamedFile);
        await renamedFile.delete();
        print('$fileName file deleted');
        final mobileNumber = await GlobalVariables.getMobileNumber();
        final fcmtoken = await FirebaseAuthenticate().getfirebasefcmtoken();
        if (fcmtoken != null) {
          await DatabaseMySQLServices.updateMobilefmcToken(
            mobileNumber: mobileNumber,
            fcmtoken: fcmtoken,
          );
        }
        if (await GlobalVariables.getNotifier() == true) {
          await NotificationServices().showNotification(
            'File Uploaded',
            '$fileName was uploaded',
          );
        }
      } else {
        await NotificationServices().showNotification(
          'Please Login',
          'Your email is not found!',
        );
      }
    } catch (e) {
      print('Error: ${e.toString()}');
    } finally {
      await ftpConnect.disconnect();
      print('disconnected from ftp');
    }
  }
}
