import 'dart:async';

import 'package:contact_tracing/classes/apiMobile.dart';
import 'package:contact_tracing/classes/globals.dart';
import 'package:contact_tracing/classes/mobile.dart';
import 'package:contact_tracing/classes/uploadClass.dart';
import 'package:contact_tracing/classes/write.dart';

import 'package:contact_tracing/pages/Mobile/addMobile.dart';
import 'package:contact_tracing/pages/Mobile/updateMobile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:vector_math/vector_math.dart';
import '../../widgets/drawer.dart';

class MobilePage extends StatefulWidget {
  static const String route = '/mobiles';

  @override
  _MobilePageState createState() {
    print("in mobiles");
    return _MobilePageState();
  }
}

class _MobilePageState extends State<MobilePage> {
  SharedPreferences prefs;
  Writefile _wf = new Writefile();

  bool _isLoading = true;
  bool _showReload = false;

  int _selectedRadioTile;
  int _myMobileId;
  //List<Mobile> users;
  bool _findSelected = false;
  var _mobiles;

  Future<void> _setSelectedRadioTile(int val) async {
    setState(() {
      _selectedRadioTile = val;
    });
    prefs = await SharedPreferences.getInstance();
    await prefs.setString('mobileId', val.toString());
  }

  Future<void> _getMyMobileId() async {
    prefs = await SharedPreferences.getInstance();
    try {
      _myMobileId = int.parse(prefs.getString("mobileId"));
    } catch (exception) {
      print(exception);
    }
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
              child: const Text('Modify'),
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

  List<Widget> _buildMobiles(List<Mobile> mobiles) {
    List<Widget> widgets = [];
    if (mobiles == null) {
      return widgets;
    }

    for (Mobile mobile in mobiles) {
      if (_findSelected) {
        _setSelectedRadioTile(mobile.mobileId);
        widgets.add(
          RadioListTile(
            groupValue: mobile.mobileId,
            value: mobile.mobileId,
            onChanged: (val) async {
              print("val = $val, selected tile = $_selectedRadioTile");
              await _setSelectedRadioTile(val);
            },
            title: Text(
              mobile.mobileName,
            ),
            subtitle: Text(
              mobile.mobileNumber,
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
            groupValue: _selectedRadioTile,
            value: mobile.mobileId,
            onChanged: (val) {
              print("val = $val, selected tile = $_selectedRadioTile");
              _setSelectedRadioTile(val);
              // setSelectedUser(val);
            },
            title: Text(
              mobile.mobileName,
            ),
            subtitle: Text(
              mobile.mobileNumber,
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
    widgets.add(
      ListTile(),
    );
    return widgets;
  }

  Widget _body() {
    if (_isLoading == true) {
      return Center(child: CircularProgressIndicator());
    } else if (_showReload == true) {
      return Center(
        child: FloatingActionButton(
            foregroundColor: Colors.red,
            backgroundColor: Colors.white,
            child: Icon(Icons.replay),
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => MobilePage(),
              ));
            }),
      );
    } else {
      return SingleChildScrollView(
        child: Column(
          children: _buildMobiles(_mobiles),
        ),
      );
    }
  }

  Widget _floatingActionButton() {
    if (_isLoading) {
      return null;
    } else if (_showReload) {
      return null;
    } else {
      return FloatingActionButton(
          //foregroundColor: Colors.red,
          child: Icon(
            Icons.add,
            // color: Colors.red,
          ),
          onPressed: () {
            setState(() {
              _isLoading = true;
            });
            Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => AddMobilePage(),
            ));
          });
    }
  }

  // void onStart() {
  //   // WidgetsFlutterBinding.ensureInitialized();
  //   print("start running service in mobiles.dart");
  //   int counter = 0;
  //   final service = FlutterBackgroundService();
  //   service.onDataReceived.listen((event) {
  //     if (event["action"] == "setAsBackground") {
  //       service.setForegroundMode(false);
  //     }

  //     if (event["action"] == "stopService") {
  //       service.stopBackgroundService();
  //     }
  //   });

  //   // bring to foreground
  //   service.setForegroundMode(true);
  //   Timer.periodic(
  //     Duration(minutes: timeToGetLocationPerMinute),
  //     (timer) async {
  //       if (!(await service.isServiceRunning())) timer.cancel();
  //       Position position = await Geolocator.getCurrentPosition(
  //         desiredAccuracy: geolocatorAccuracy,
  //       );
  //       final SharedPreferences prefs = await SharedPreferences.getInstance();
  //       if (prefs.getString("username") != null) {
  //         _wf.writeToFile(
  //             '${position.latitude.toString()}',
  //             '${position.longitude.toString()}',
  //             '${position.accuracy.toString()}');
  //         if (counter > timeToUploadPerMinute) {
  //           UploadFile uploadFile = new UploadFile();
  //           uploadFile.uploadToServer();
  //           counter = 0;
  //         }
  //       }
  //       service.setNotificationInfo(
  //         title: "Contact tracing",
  //         content:
  //             "Updated at ${DateTime.now()} \nLatitude: ${position.latitude.toString()} \nLongitude: ${position.longitude.toString()}",
  //       );

  //       service.sendData(
  //         {"current_date": DateTime.now().toIso8601String()},
  //       );
  //       counter = counter + 1;
  //     },
  //   );
  // }

// Future<void> backgroundHandler(RemoteMessage message) async {
//   print(message.data.toString());
//   print(message.notification.title);
// }

  @override
  void initState() {
    _getMyMobileId().whenComplete(() => setState(() {
          //_isLoading = false;
          if (_myMobileId != null) {
            _findSelected = false;
            _selectedRadioTile = _myMobileId;
          } else {
            _findSelected = true;
            _selectedRadioTile = 0;
          }
        }));
    ApiMobile.getMobiles().then((mobileList) => setState(() {
          _mobiles = mobileList;
          _isLoading = false;
          print('is loading false');

          try {
            final mobileMap = mobileList.asMap();
            Mobile firstMobileInList = mobileMap[0];
            if (firstMobileInList.mobileId == 0) {
              _showReload = true;
              print('show reload is true');
            } else if ((mobileList.length == 1) ||
                (prefs.getBool('justLogin') == true)) {
              //add the first mobile
              print(
                  'add the first mobile and start service || logged in and have mobile(s), start services and remove justLogin');
              _setSelectedRadioTile(firstMobileInList.mobileId);
              prefs.remove('justLogin');
              //  start bg services
              FlutterBackgroundService().sendData({"action": "startService"});
            }
            // else if  {
            //   //login and have mobile(s)
            //   print(
            //       '');
            //   //  start bg services

            //   _setSelectedRadioTile(firstMobileInList.mobileId);
            //   FlutterBackgroundService().sendData({"action": "startService"});
            // }
            // }
          } catch (e) {
            print(e.toString());
            _showReload = true;
          }
        }));
    super.initState();
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
          body: _body(),
          floatingActionButton: _floatingActionButton(),
        ),
      ),
    );
  }
}
