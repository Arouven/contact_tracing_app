import 'dart:convert';
//import 'package:http/http.dart' as http;
import 'databaseServices.dart';
import 'globals.dart';
import '../models/mobile.dart';

class ApiMobile {
  static Future<List<Mobile>> getMobiles() async {
    print("in apiMobile, getMobiles");
    try {
      final email = await GlobalVariables.getEmail();
      if (email != null) {
        final mobiles = await DatabaseMySQLServices.getMobiles(email: email);
        print(mobiles);
        if (mobiles != null) {
          print('not null');
          return mobiles.map<Mobile>(Mobile.fromJson).toList();
        }
        print('null from api');
        return [];
      }
      print('null email');
      return [];
    } catch (e) {
      print('exception in apiMobile');
      print(e);
      return [];
    }
  }
}
