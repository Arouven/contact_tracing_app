import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'globals.dart';
import 'mobile.dart';

class ApiMobile {
  static Future<List<Mobile>> getMobiles() async {
    print("in apiMobile, getMobiles");
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String username = prefs.getString('username');
      final res = await http
          .post(Uri.parse(getMobilesUrl), body: {"username": username});
      final body = json.decode(res.body);
      final mobiles = body['mobiles'];
      print(mobiles);
      if (mobiles != null) {
        print('not null');
        return mobiles.map<Mobile>(Mobile.fromJson).toList();
      }
      print('null from api');
      return null;
    } catch (e) {
      print(e);
      final non = "[0]";
      final body = jsonDecode(non);
      return body.map<Mobile>(Mobile.problem).toList();
    }
  }
}
