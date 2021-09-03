import 'package:contact_tracing/classes/apiMobile.dart';
import 'package:contact_tracing/classes/mobile.dart';

import 'package:contact_tracing/pages/addMobile.dart';
import 'package:contact_tracing/pages/splash.dart';
import 'package:contact_tracing/pages/updateMobile.dart';
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
  bool _isLoading = true;
  int selectedRadioTile;
  int _myMobileId;
  List<Mobile> users;
  bool _findSelected = false;
  var _mobiles;

  @override
  void initState() {
    getMyMobileId().whenComplete(() => setState(
          () {
            //_isLoading = false;
            if (_myMobileId != null) {
              _findSelected = false;
              selectedRadioTile = _myMobileId;
            } else {
              _findSelected = true;
              selectedRadioTile = 0;
            }
          },
        ));
    ApiMobile.getMobiles().then((value) => setState(() {
          _mobiles = value;
          _isLoading = false;
        }));
    super.initState();
  }

  Future<void> setSelectedRadioTile(int val) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('mobileId', val.toString());
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

  Future<void> _showEditDialog(Mobile mobile) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Modify Mobile',
            style: TextStyle(
              color: Colors.orange,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                new Row(
                  children: [
                    Expanded(
                      child: Text(
                          'Are you sure you want to make changes to "${mobile.mobileName}" mobile?'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Accept'),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                        UpdateMobilePage(mobile: mobile),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  List<Widget> buildMobiles(List<Mobile> mobiles) {
    List<Widget> widgets = [];
    for (Mobile mobile in mobiles) {
      if (_findSelected) {
        widgets.add(
          RadioListTile(
            groupValue: mobile.mobileId,
            value: mobile.mobileId,
            onChanged: (val) {
              print("val = $val, selected tile = $selectedRadioTile");
              setSelectedRadioTile(val);
            },
            title: Text(
              mobile.mobileName,
            ),
            subtitle: Text(
              mobile.mobileDescription,
            ),
            secondary: new IconButton(
              icon: new Icon(Icons.edit),
              onPressed: () {
                //setState(() {
                print('mobile press');
                _showEditDialog(mobile);
                // });
              },
            ),
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
              onPressed: () {
                //setState(() {
                print('mobile press');
                _showEditDialog(mobile);
                // });
              },
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
    //var moblies = ApiMobile.getMobiles();
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
          body: _isLoading
              ? Center(child: CircularProgressIndicator())
              : Column(children: buildMobiles(_mobiles)),
          floatingActionButton: _isLoading
              ? null
              : FloatingActionButton(
                  child: Icon(Icons.add),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => AddMobilePage(),
                    ));
                  } //addItem,
                  ),
        ),
      ),
    );
  }
}
