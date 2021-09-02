import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;
import 'globals.dart';

class Mobile {
  int mobileId;
  String mobileName;
  String mobileDescription;

  Mobile({this.mobileId, this.mobileName, this.mobileDescription});

  static Future<List<Mobile>> getMobiles() async {
    //SELECT Mobile.mobileId,Mobile.mobileName,Mobile.mobileDescription FROM Mobile INNER JOIN User ON Mobile.userId=User.userId WHERE User.username='Johny'

    List<Mobile> mymobiles = [];
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString('username');

    final res =
        await http.post(Uri.parse(getMobilesUrl), body: {"username": username});
    final data = jsonDecode(res.body);
    //_displayError = false;
    if (data['msg'] == "data does not exist") {
      //new user no mobile in db
      //print(data);
    } else {
      //"User has mobiles";

      var mobiles = data['mobiles'];
      print(mobiles);
      for (var mobile in mobiles) {
        mymobiles.add(
          Mobile(
              mobileId: mobile['mobileId'],
              mobileName: mobile['mobileName'],
              mobileDescription: mobile['mobileDescription']),
        );
      }
    }

    // final mobiledata = List<Mobile>.from(
    //   data.map<dynamic>(
    //     (dynamic item) => mymobiles,
    //   ),
    // );
    return mymobiles;
  }
}
