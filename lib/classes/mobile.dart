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
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString('username');

    final res =
        await http.post(Uri.parse(getMobilesUrl), body: {"username": username});
    final data = jsonDecode(res.body);
    //_displayError = false;
    if (data['msg'] == "data does not exist") {
    } else {
      //"User has mobiles";

      print(data);
    }
    return <Mobile>[
      Mobile(mobileId: 1, mobileName: "Aaron", mobileDescription: "Jackson"),
      Mobile(mobileId: 2, mobileName: "Ben", mobileDescription: "John"),
      Mobile(mobileId: 3, mobileName: "Carrie", mobileDescription: "Brown"),
      Mobile(mobileId: 4, mobileName: "Deep", mobileDescription: "Sen"),
      Mobile(mobileId: 5, mobileName: "Emily", mobileDescription: "Jane"),
    ];
  }
}
