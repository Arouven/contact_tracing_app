import 'package:contact_tracing/models/mobile.dart';
import 'package:contact_tracing/services/databaseServices.dart';
import 'package:contact_tracing/services/globals.dart';

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
