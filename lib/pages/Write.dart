import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
//import 'package:english_words/english_words.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: ReadWriteFile(),
    );
  }
}

class _ReadWriteFileAppState extends State<ReadWriteFile> {
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

  Future _writeToFile(String text) async {
    final file = await _localFile;
    // Write the file
    bool isExisted = file.existsSync();
    String headerFile = 'DateTime,Longitude,Latitude,Accuracy\n';
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

  @override
  void initState() {
    super.initState();
    _requestAllPermissions();
  }

  _requestAllPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.storage,
      Permission.manageExternalStorage,
    ].request();
    print(statuses[Permission.location]);
  }

  @override
  Widget build(BuildContext context) {
    _writeToFile("${DateTime.now()},Longitude,Latitude,Accuracy");
    return Scaffold(
      appBar: AppBar(
        title: Text('Writing File'),
      ),
      body: Center(
        child: Text("super working"),
      ),
    );
  }
}

class ReadWriteFile extends StatefulWidget {
  @override
  _ReadWriteFileAppState createState() => new _ReadWriteFileAppState();
}
