import 'dart:async';
import 'dart:io';
import 'package:contact_tracing/services/globals.dart';
import 'package:path_provider/path_provider.dart';

class Writefile {
  Writefile() {
    _localFile;
  }

  Future get _localFile async {
    print("in Writefile");
    // Application documents directory: /data/user/0/{package_name}/{app_name}
    //final applicationDirectory = await getApplicationDocumentsDirectory();

    // External storage directory: /storage/emulated/0
    final externalDirectory = await getExternalStorageDirectory();

    final fullPath = externalDirectory!.path;

    final email = await GlobalVariables.getEmail();
    var fullFilePath = '$fullPath/${email}_geolocatorbest.csv';
    await GlobalVariables.setFileDirectory(fileDirectory: '$fullPath/');
//Retrive different types of data

    /*
    /storage/emulated/0/Android/data/com.example.readwrite/files/xxx.txt
    */
    return File(fullFilePath);
  }

  Future writeToFile(String latitude, String longitude, String accuracy) async {
    print("in Writefile");
    final file = await _localFile;

    String time = (new DateTime.now().millisecondsSinceEpoch).toString();
    time = time.substring(0, time.length - 3);

    final mobileNumber = await GlobalVariables.getMobileNumber();
    String text = '$mobileNumber,$time,$latitude,$longitude,$accuracy\n';

    File result;
    if (file.existsSync()) {
      print('file already exists adding data');
      result = await file.writeAsString('$text', mode: FileMode.append);
    } else {
      print('no file, creating it');
      result = await file.writeAsString('$text');
    }
    print(result.toString());
    if (result == null) {
      print("Writing to file failed");
    } else {
      print("Successfully writing to file");
    }
  }
}
