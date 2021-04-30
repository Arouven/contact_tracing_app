import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class readWritecsv {
  //bool _allowWriteFile = false;

  Future get _localPath async {
    // Application documents directory: /data/user/0/{package_name}/{app_name}
    //final applicationDirectory = await getApplicationDocumentsDirectory();

    // External storage directory: /storage/emulated/0
    final externalDirectory = await getExternalStorageDirectory();

    return externalDirectory.path;
  }

  Future get _localFile async {
    final path = await _localPath;
    var fileName = 'csvfile.txt';
    var f = '$path/$fileName';
    print('the path is: $f');
    /*
    /storage/emulated/0/Android/data/com.example.readwrite/files/xxx.txt
    */
    return File(f);
  }

  Future writeToFile(String text) async {
    final file = await _localFile;
    // Write the file
    bool isExisted = file.existsSync();
    String headerFile = 'DateTime,Latitude,Longitude,Accuracy\n';
    // ignore: unrelated_type_equality_checks
    if (isExisted) {
      print('file already exists adding data');
      File result = await file.writeAsString('$text\n', mode: FileMode.append);
      if (result == null) {
        print("Writing to file failed");
      } else {
        print("Successfully writing to file");
      }
    } else {
      print('no file, creating it');
      File result = await file.writeAsString('$headerFile$text\n');
      if (result == null) {
        print("Writing to file failed");
      } else {
        print("Successfully writing to file");
      }
    }
  }
}

// class ReadWriteFile extends StatefulWidget {
//   @override
//   _ReadWriteFileAppState createState() => new _ReadWriteFileAppState();
// }
