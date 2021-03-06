import 'dart:convert';
import 'package:contact_tracing/models/message.dart';
import 'package:contact_tracing/services/globals.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;

class DatabaseMySQLServices {
  static int _secondstimeout = 120;

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
      ).timeout(
        Duration(
          seconds: _secondstimeout,
        ),
        onTimeout: () {
          // Time has run out, do what you wanted to do.
          return http.Response(
              'Error', 500); // Replace 500 with your http code.
        },
      );
      print(res.body);
      return jsonDecode(res.body);
    } catch (e) {
      print(e);
      return 'Error';
    }
  }

  static Future getMobiles({required String email}) async {
    final res = await http.post(
      Uri.parse(getMobilesUrl),
      body: {"email": email},
    ).timeout(
      Duration(
        seconds: _secondstimeout,
      ),
      onTimeout: () {
        return http.Response('Error', 500);
      },
    );
    final body = json.decode(res.body);
    print(body);
    final mobiles = body['mobiles'];
    return mobiles;
  }

  static Future downloadUpdateLocation() async {
    try {
      final res = await http.get(Uri.parse(latestUpdateLocationsUrl)).timeout(
        Duration(
          seconds: _secondstimeout,
        ),
        onTimeout: () {
          // Time has run out, do what you wanted to do.
          return http.Response(
              'Error', 500); // Replace 500 with your http code.
        },
      );
      return res.body;
    } catch (e) {
      return 'Error';
    }
  }

  static Future getUserInfo({required String email}) async {
    try {
      final res = await http.post(
        Uri.parse(getUserInfoUrl),
        body: {
          'email': email,
        },
      ).timeout(
        Duration(
          seconds: _secondstimeout,
        ),
        onTimeout: () {
          // Time has run out, do what you wanted to do.
          return http.Response(
              'Error', 500); // Replace 500 with your http code.
        },
      );
      return res.body;
    } catch (e) {
      return 'Error';
    }
  }

  static Future updateDateOfBirth(
      {required String email, required String dateOfBirth}) async {
    final res = await http.post(
      Uri.parse(updateDateOfBirthUrl),
      body: {
        "email": email,
        'dateOfBirth': dateOfBirth.trim(),
      },
    ).timeout(
      Duration(
        seconds: _secondstimeout,
      ),
      onTimeout: () {
        // Time has run out, do what you wanted to do.
        return http.Response('Error', 500); // Replace 500 with your http code.
      },
    );
    final body = json.decode(res.body);
    print(body);
    return body;
  }

  static Future updateName(
      {required String email,
      required String firstName,
      required String lastName}) async {
    final res = await http.post(
      Uri.parse(updateNameUrl),
      body: {
        "email": email,
        'firstName': firstName,
        'lastName': lastName,
      },
    ).timeout(
      Duration(
        seconds: _secondstimeout,
      ),
      onTimeout: () {
        // Time has run out, do what you wanted to do.
        return http.Response('Error', 500); // Replace 500 with your http code.
      },
    );
    final body = json.decode(res.body);
    print(body);
    return body;
  }

  static Future updateAddress({
    required String email,
    required String address,
  }) async {
    final res = await http.post(
      Uri.parse(updateAddressUrl),
      body: {
        "email": email,
        'address': address,
      },
    ).timeout(
      Duration(
        seconds: _secondstimeout,
      ),
      onTimeout: () {
        // Time has run out, do what you wanted to do.
        return http.Response('Error', 500); // Replace 500 with your http code.
      },
    );
    final body = json.decode(res.body);
    print(body);
    return body;
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
      }).timeout(
        Duration(
          seconds: _secondstimeout,
        ),
        onTimeout: () {
          return http.Response('Error', 500);
        },
      );
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
      ).timeout(
        Duration(
          seconds: _secondstimeout,
        ),
        onTimeout: () {
          // Time has run out, do what you wanted to do.
          return http.Response(
              'Error', 500); // Replace 500 with your http code.
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
      ).timeout(
        Duration(
          seconds: _secondstimeout,
        ),
        onTimeout: () {
          // Time has run out, do what you wanted to do.
          return http.Response(
              'Error', 500); // Replace 500 with your http code.
        },
      );
//update firebase too
      return jsonDecode(res.body);
    } catch (e) {
      print(e.toString());
      return 'Error';
    }
  }

  // static Future setMobileActive({
  //   required String mobileNumber,
  //   required String fcmtoken,
  // }) async {
  //   try {
  //     final res = await http.post(
  //       Uri.parse(setMobileActiveUrl),
  //       body: {
  //         "mobileNumber": mobileNumber,
  //         "fcmtoken": fcmtoken,
  //       },
  //     );
  //     return jsonDecode(res.body);
  //   } catch (e) {
  //     print(e.toString());
  //     return 'Error';
  //   }
  // }
}

class DatabaseFirebaseServices {
  static Future markRead(
      {required Message message, required String path}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("$path${message.id}");
    await ref.update({
      "read": true,
    });
  }

  // static Future updateFirebaseToken(
  //     {required String oldfcmtoken,
  //     required String newfcmtoken,
  //     required String path}) async {
  //   // DatabaseReference ref = FirebaseDatabase.instance.ref("$path${message.id}");
  //   // await ref.update({
  //   //   "read": true,
  //   // });
  // }
}
