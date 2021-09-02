import 'package:contact_tracing/classes/mobile.dart';

import 'package:contact_tracing/pages/addMobile.dart';
import 'package:contact_tracing/pages/splash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter/services.dart';

// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong/latlong.dart';
// import 'package:geolocator/geolocator.dart';
import '../widgets/drawer.dart';

class MobilePage extends StatefulWidget {
  static const String route = '/mobiles';

  @override
  _MobilePageState createState() {
    return _MobilePageState();
  }
}

class _MobilePageState extends State<MobilePage> {
  @override
  void initState() {
    super.initState();
  }

  final mobiles = ['work', 'home'];
  Future<void> addItem() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('mobileId', '8');
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => AddMobilePage()));
    print('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');
    Mobile.getMobiles();

    //Navigator.of(context)
    //   .push(MaterialPageRoute(builder: (context) => SplashPage()));
    // setState(
    //   () {
    //     mobiles.add(mobiles[-1]);
    //   }
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        top: true,
        bottom: true,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Mobiles'),
            centerTitle: true,
            backgroundColor: Colors.blue,
          ),
          drawer: buildDrawer(context, MobilePage.route),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.separated(
              itemCount: mobiles.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(mobiles[index]),
                );
              },
              separatorBuilder: (context, index) {
                return Divider();
              },
            ),
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: addItem,
          ),
        ),
      ),
    );
  }
}
