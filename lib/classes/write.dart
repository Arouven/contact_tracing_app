import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Writefile {
  String fileName;
  //String localFileName;

  Writefile(this.fileName) {
    _localFile;
  }

  Future get _localFile async {
    // Application documents directory: /data/user/0/{package_name}/{app_name}
    //final applicationDirectory = await getApplicationDocumentsDirectory();

    // External storage directory: /storage/emulated/0
    final externalDirectory = await getExternalStorageDirectory();

    final fullPath = externalDirectory.path;
    var fullFilePath = '$fullPath/${this.fileName}';

    //saved in global var
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("fullFilePath", fullFilePath);

//Retrive different types of data

    print('the path is saved as "fullFilePath"');
    /*
    /storage/emulated/0/Android/data/com.example.readwrite/files/xxx.txt
    */
    return File(fullFilePath);
  }

  Future writeToFile(String latitude, String longitude, String accuracy) async {
    final file = await _localFile;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String text =
        '${prefs.getString("mobileID")},${DateTime.now().toString()},$latitude,$longitude,$accuracy\n';
    File result;
    if (file.existsSync()) {
      print('file already exists adding data');
      result = await file.writeAsString('$text\n', mode: FileMode.append);
    } else {
      print('no file, creating it');
      result = await file.writeAsString('$text\n');
    }
    if (result == null) {
      print("Writing to file failed");
    } else {
      print("Successfully writing to file");
    }
  }
}
