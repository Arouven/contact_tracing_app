import 'dart:convert';
import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../classes/globals.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'mobiles.dart';
import 'dart:async';
import 'package:flutter/services.dart';

class AddMobilePage extends StatefulWidget {
  //final Mobile mobile;
  static const String route = '/addMobile';
  // const UpdateMobilePage({
  //   Key key,
  //   @required this.mobile,
  // }) : super(key: key);
  @override
  _AddMobilePageState createState() => _AddMobilePageState();
}

class _AddMobilePageState extends State<AddMobilePage> {
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  String _deviceData = "";
  bool _isLoading = false;
  TextEditingController _mobileName = TextEditingController();
  TextEditingController _mobileDescription = TextEditingController();
  TextEditingController _mobileNumber = TextEditingController();
  Country _selected;
  @override
  void initState() {
    super.initState();
    initPlatformState().whenComplete(() => setState(() {
          _mobileName.text = _deviceData;
          _isLoading = false;
        }));
  }

  Future<void> initPlatformState() async {
    String deviceData = "";
    try {
      if (Platform.isAndroid) {
        deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      } else if (Platform.isIOS) {
        deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
      }
    } on PlatformException {
      deviceData = 'Error:';
    }

    if (!mounted) return;

    setState(() {
      _deviceData = deviceData;
    });
  }

  String _readAndroidBuildData(AndroidDeviceInfo build) {
    return build.model.toString();
  }

  String _readIosDeviceInfo(IosDeviceInfo data) {
    return data.model.toString();
  }

  Future<void> _showDiscardDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Discard Changes',
            style: TextStyle(
              color: Colors.red,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                new Row(
                  children: [
                    Expanded(
                      child: Text(
                          'Are you sure you want to discard changes made?'),
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
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => MobilePage()),
                    (e) => false);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showAcceptDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Save Changes',
            style: TextStyle(color: Colors.orange),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                new Row(
                  children: [
                    Expanded(
                      child:
                          Text('Are you sure you want to save the new phone?'),
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
              onPressed: () async {
                Navigator.of(context).pop();
                await saveToDb();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> saveToDb() async {
    setState(() {
      _isLoading = true;
    });
    final url = addMobileUrl;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var username = prefs.getString('username');

    // var fn = '${username}_geolocatorbest.csv';
    // await prefs.setString("fileName", fn);

    final res = await http.post(Uri.parse(url), body: {
      "username": username,
      "mobileName": _mobileName.text.toString(),
      "mobileDescription": _mobileDescription.text.toString(),
      "mobileNumber": _mobileNumber.text.toString()
    });
    final data = jsonDecode(res.body);
    print(data);
    if (data['msg'] == "added") {
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => MobilePage()), (e) => false);
    }
  }

  Widget displayCircle() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 1.3,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
          // Padding(
          //   //padding: EdgeInsets.only(top: 16),
          //   child:
          Text('Awaiting result...'),
          // )
        ],
      ),
    );
  }

  Widget displayMobile() {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Center(
        child: ListView(
          children: <Widget>[
            _buildTextFields(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextFields() {
    return new Container(
      child: new Column(
        children: <Widget>[
          new Container(
              child: new Row(
            children: <Widget>[
              Expanded(
                child: new TextField(
                  controller: _mobileName,
                  decoration: new InputDecoration(labelText: 'Mobile Name'),
                ),
              ),
              IconButton(
                icon: Icon(Icons.info),
                color: Colors.black,
                iconSize: 30.0,
                alignment: Alignment.centerRight,
                onPressed: () {
                  setState(() {
                    _mobileName.text = _deviceData;
                  });
                },
              ),
            ],
          )),
          new Container(
            child: new Row(
              children: <Widget>[
                Expanded(
                  child: new TextField(
                    controller: _mobileDescription,
                    decoration:
                        new InputDecoration(labelText: 'Mobile Description'),
                  ),
                ),
              ],
            ),
          ),
          new Container(
            child: new Row(
              children: <Widget>[
                Expanded(
                  flex: 3,
                  //SizedBox(height: 20.0),
                  child: CountryPicker(
                    dense: true,
                    //displays flag, true by default
                    showFlag: false,
                    //displays dialing code, false by default
                    showDialingCode: true,
                    //displays country name, true by default
                    showName: true,
                    showCurrency: false, //eg. 'British pound'
                    showCurrencyISO: false,
                    onChanged: (Country country) {
                      setState(() {
                        _selected = country;
                        print(country.dialingCode);
                      });
                      //countryCode = country.dialingCode;
                    },
                    selectedCountry: _selected,
                  ),
                ),
                Expanded(
                  flex: 3,
                  //SizedBox(height: 20.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Mobile no.',
                      border: OutlineInputBorder(),
                    ),
                    validator: (val) => val.length != 10
                        ? 'Enter a mobile number of 10 digits'
                        : null,
                    onChanged: (val) {
                      //setState(() => phone = val);
                      //phoneno = phone;
                    },
                  ),
                ),
              ],
            ),
            // TextField(
            //   controller: _mobileNumber,
            //   decoration: new InputDecoration(labelText: 'Mobile Number'),
            // ),
          )
        ],
      ),
    );
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
            leading: IconButton(
              icon: Icon(
                Icons.clear_outlined,
                color: Colors.red,
              ),
              onPressed: () {
                _showDiscardDialog();
              },
            ),
            automaticallyImplyLeading: true,
            backgroundColor: Colors.blue[100],
            title: Text(
              'New Mobile',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            centerTitle: true,
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.check_outlined,
                  color: Colors.green,
                ),
                onPressed: () {
                  _showAcceptDialog();
                },
              ),
            ],
          ),
          body: _isLoading ? displayCircle() : displayMobile(),
        ),
      ),
    );
  }
}
