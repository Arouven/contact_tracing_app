import 'package:contact_tracing/classes/apiMobile.dart';
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
  // final mobiles = ['work', 'home'];
  // Future<void> addItem() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.setString('mobileId', '8');
  //   Navigator.of(context)
  //       .push(MaterialPageRoute(builder: (context) => AddMobilePage()));
  //   print('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');
  //   Mobile.getMobiles();

  //   //Navigator.of(context)
  //   //   .push(MaterialPageRoute(builder: (context) => SplashPage()));
  //   // setState(
  //   //   () {
  //   //     mobiles.add(mobiles[-1]);
  //   //   }
  //   // );
  // }
  bool _isLoading = true;
  int selectedRadioTile;
  int _myMobileId;
  List<Mobile> users;
  bool _findSelected = false;

  @override
  void initState() {
    super.initState();
    getMyMobileId().whenComplete(() => setState(
          () {
            if (_myMobileId != null) {
              _findSelected = false;
              selectedRadioTile = _myMobileId;
            } else {
              _findSelected = true;
              selectedRadioTile = 0;
            }
          },
        ));
  }

  void setSelectedRadioTile(int val) {
    setState(() {
      selectedRadioTile = val;
    });
  }

  Future<void> getMyMobileId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      _myMobileId = int.parse(prefs.getString("mobileId"));
    } catch (exception) {}
  }

  List<Widget> buildMobiles(List<Mobile> mobiles) {
    List<Widget> widgets = [];
    //isInList(mobiles);
    //int i = 0;
    for (Mobile mobile in mobiles) {
      //selectedId = mobile.mobileId;
      if (_findSelected) {
        widgets.add(
          RadioListTile(
            groupValue: mobile.mobileId,
            value: mobile.mobileId,
            onChanged: (val) {
              print("val = $val, selected tile = $selectedRadioTile");
              setSelectedRadioTile(val);
              // setSelectedUser(val);
            },
            title: Text(
              mobile.mobileName,
            ),
            subtitle: Text(
              mobile.mobileDescription,
            ),
            secondary: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {},
            ),
            //selected: selectedUser == mobile,
          ),
        );
        _findSelected = false;
      } else {
        widgets.add(
          RadioListTile(
            groupValue: selectedRadioTile,
            value: mobile.mobileId,
            onChanged: (val) {
              print("val = $val, selected tile = $selectedRadioTile");
              setSelectedRadioTile(val);
              // setSelectedUser(val);
            },
            title: Text(
              mobile.mobileName,
            ),
            subtitle: Text(
              mobile.mobileDescription,
            ),
            secondary: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {},
            ),
            //selected: selectedUser == mobile,
          ),
        );
      }
    }
    return widgets;
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
          body: FutureBuilder<List<Mobile>>(
            future: ApiMobile.getMobiles(),
            builder: (context, snapshot) {
              final moblies = snapshot.data;
              _isLoading = true;
              if (snapshot.hasError) {
                return Center(child: Text('Some error occurred!'));
              } else if (snapshot.hasData) {
                _isLoading = false;
                return Column(children: buildMobiles(moblies));
              } else {
                return Center(child: CircularProgressIndicator());
              }

              // switch (snapshot.connectionState) {
              //   case ConnectionState.waiting:
              //     return Center(child: CircularProgressIndicator());
              //   default:
              //     if (snapshot.hasError) {
              //       return Center(child: Text('Some error occurred!'));
              //     } else {
              //       return Column(children: buildMobiles(moblies));
              //     }
              // }
            },
          ),
          floatingActionButton: _isLoading
              ? null
              : FloatingActionButton(
                  child: Icon(Icons.add), onPressed: () {} //addItem,
                  ),
        ),
      ),
    );
  }
}
