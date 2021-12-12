import 'dart:convert';
import 'globals.dart';
import 'package:http/http.dart' as http;

class DatabaseServices {
  Future registerUser({
    String firstName = '',
    String lastName = '',
    String address = '',
    String dateOfBirth = '',
    String email = '',
    String firebaseuid = '',
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

  Future emailExist(String email) async {
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
    String firebaseuid = '',
    String mobileName = '',
    String mobileDescription = '',
    String mobileNumber = '',
    String fcmtoken = '',
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
    String mobileId = '',
    String mobileName = '',
    String mobileDescription = '',
    String mobileNumber = '',
    String fcmtoken = '',
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
}
