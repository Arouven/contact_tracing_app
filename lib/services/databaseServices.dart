import 'dart:convert';
import 'package:contact_tracing/models/message.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'globals.dart';
import 'package:http/http.dart' as http;

class DatabaseServices {
  static Future registerUser({
    required String firstName,
    required String lastName,
    required String address,
    required String dateOfBirth,
    required String email,
  }) async {
    try {
      final res = await http.post(
        Uri.parse(registerUrl),
        body: {
          'firstName': firstName,
          'lastName': lastName,
          'address': address,
          'dateOfBirth': dateOfBirth,
          'email': email,
        },
      );
      print(res.body);
      return jsonDecode(res.body);
    } catch (e) {
      print(e);
      return 'Error';
    }
  }

  // Future emailExist({required String email}) async {
  //   // setState(() {
  //   //   _emailInDB = null;
  //   // });
  //   bool? _emailInDB;
  //   try {
  //     final res = await http.post(
  //       Uri.parse(checkEmailUrl),
  //       body: {'email': email},
  //     );
  //     final data = jsonDecode(res.body);
  //     if (data['msg'] == 'email already in db') {
  //       print(data['msg']);
  //       _emailInDB = true;
  //     } else if (data['msg'] == 'email not in db') {
  //       print(data['msg']);
  //       _emailInDB = false;
  //     } else {
  //       _emailInDB = null;
  //     }
  //   } on Exception {
  //     _emailInDB = null;
  //   }
  //   return _emailInDB;
  // }

  static Future downloadUpdateLocation() async {
    try {
      final res = await http.get(Uri.parse(latestUpdateLocationsUrl));
      return res.body;
    } catch (e) {
      return 'Error';
    }
  }

  static Future addMobile({
    required String mobileName,
    required String email,
    required String mobileNumber,
    required String fcmtoken,
  }) async {
    try {
      final res = await http.post(Uri.parse(addMobileUrl), body: {
        "mobileName": mobileName,
        "email": email,
        "mobileNumber": mobileNumber,
        "fcmtoken": fcmtoken,
      });
      return jsonDecode(res.body);
    } catch (e) {
      print(e.toString());
      return 'Error';
    }
  }

  static Future updateMobile({
    required String mobileNumber,
    required String mobileName,
    required String email,
    required String fcmtoken,
  }) async {
    try {
      final res = await http.post(
        Uri.parse(updateMobileUrl),
        body: {
          "mobileName": mobileName,
          "email": email,
          "mobileNumber": mobileNumber,
          "fcmtoken": fcmtoken,
        },
      );
      return jsonDecode(res.body);
    } catch (e) {
      print(e.toString());
      return 'Error';
    }
  }

  static Future updateMobilefmcToken({
    required String mobileNumber,
    required String fcmtoken,
  }) async {
    try {
      final res = await http.post(
        Uri.parse(updateMobilefmcTokenUrl),
        body: {
          "mobileNumber": mobileNumber,
          "fcmtoken": fcmtoken,
        },
      );
//update firebase too
      return jsonDecode(res.body);
    } catch (e) {
      print(e.toString());
      return 'Error';
    }
  }

  static Future markRead(
      {required Message message, required String path}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("$path${message.id}");
    await ref.update({
      "read": true,
    });
  }

  static Future updateFirebaseToken(
      {required String oldfcmtoken,
      required String newfcmtoken,
      required String path}) async {
    // DatabaseReference ref = FirebaseDatabase.instance.ref("$path${message.id}");
    // await ref.update({
    //   "read": true,
    // });
  }
}
