import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'globals.dart';
import '../models/mobile.dart';

class ApiMobile {
  static Future<List<Mobile>> getMobiles() async {
    print("in apiMobile, getMobiles");
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('email');
      if (email == null) return [];
      final res =
          await http.post(Uri.parse(getMobilesUrl), body: {"email": email});
      final body = json.decode(res.body);
      print(body);
      final mobiles = body['mobiles'];
      print(mobiles);
      if (mobiles != null) {
        print('not null');
        return mobiles.map<Mobile>(Mobile.fromJson).toList();
      }
      print('null from api');
      return [];
    } catch (e) {
      print(e);
      // final non = "[0]";
      // final body = jsonDecode(non);
      return [];
      //body.map<Mobile>(Mobile.problem).toList();
    }
  }
}
