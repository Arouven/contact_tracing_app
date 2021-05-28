import 'dart:async';
import 'dart:io';

import 'package:contact_tracing/classes/uploadClass.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './notification.dart';
import 'package:workmanager/workmanager.dart';

class Background {
  void taskPushFtpServer() {
    UploadFile uploadFile = new UploadFile();
    uploadFile.uploadToServer();
    print('in backkground class');
  }
}
