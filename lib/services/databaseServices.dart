import 'dart:convert';
import 'package:contact_tracing/models/message.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'globals.dart';
import 'package:http/http.dart' as http;

class DatabaseServices {
  Future registerUser({
    required String firstName,
    required String lastName,
    required String address,
    required String dateOfBirth,
    required String email,
    required String firebaseuid,
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
          'firebaseuid': firebaseuid
        },
      );
      print(res.body);
      return jsonDecode(res.body);
    } catch (e) {
      print(e);
      return 'Error';
    }
  }

  Future emailExist({required String email}) async {
    // setState(() {
    //   _emailInDB = null;
    // });
    bool? _emailInDB;
    try {
      final res = await http.post(
        Uri.parse(checkEmailUrl),
        body: {'email': email},
      );
      final data = jsonDecode(res.body);
      if (data['msg'] == 'email already in db') {
        print(data['msg']);
        _emailInDB = true;
      } else if (data['msg'] == 'email not in db') {
        print(data['msg']);
        _emailInDB = false;
      } else {
        _emailInDB = null;
      }
    } on Exception {
      _emailInDB = null;
    }
    return _emailInDB;
  }

  Future downloadUpdateLocation() async {
    try {
      final res = await http.get(Uri.parse(latestUpdateLocationsUrl));
      return res.body;
    } catch (e) {
      return 'Error';
    }
  }

  Future addMobile({
    required String firebaseuid,
    required String mobileName,
    required String mobileDescription,
    required String mobileNumber,
    required String fcmtoken,
  }) async {
    try {
      final res = await http.post(Uri.parse(addMobileUrl), body: {
        "firebaseuid": firebaseuid,
        "mobileName": mobileName,
        "mobileDescription": mobileDescription,
        "mobileNumber": mobileNumber,
        "fcmtoken": fcmtoken,
      });
      return jsonDecode(res.body);
    } catch (e) {
      print(e.toString());
      return 'Error';
    }
  }

  Future updateMobile({
    required String mobileId,
    required String mobileName,
    required String mobileDescription,
    required String mobileNumber,
    required String fcmtoken,
  }) async {
    try {
      final res = await http.post(
        Uri.parse(updateMobileUrl),
        body: {
          "mobileId": mobileId,
          "mobileName": mobileName,
          "mobileDescription": mobileDescription,
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

  Future updateMobilefmcToken({
    required String mobileId,
    required String fcmtoken,
  }) async {
    try {
      final res = await http.post(
        Uri.parse(updateMobilefmcTokenUrl),
        body: {
          "mobileId": mobileId,
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

  Future markRead({required Message message, required String path}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("$path${message.id}");
    await ref.update({
      "read": true,
    });
  }

  Future updateFirebaseToken(
      {required String oldfcmtoken,
      required String newfcmtoken,
      required String path}) async {
    // DatabaseReference ref = FirebaseDatabase.instance.ref("$path${message.id}");
    // await ref.update({
    //   "read": true,
    // });
  }
}
