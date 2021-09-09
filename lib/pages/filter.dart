import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/drawer.dart';

class FilterPage extends StatefulWidget {
  static const String route = '/filter';

  @override
  _FilterPageState createState() {
    return _FilterPageState();
  }
}

class _FilterPageState extends State<FilterPage> {
  bool _myPosition = false;
  bool _testingCenters = false;
  bool _infectedMobiles = false;
  bool _contacts = false;
  bool _safeMobile = false;

  @override
  void initState() {
    super.initState();

    initCheckboxes().whenComplete(() {
      setState(() {});
    });
  }

  Future<void> initCheckboxes() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.setBool('myPosition', true);
    // await prefs.setBool('testingCenters', true);
    // await prefs.setBool('infectedMobiles', true);
    // await prefs.setBool('contacts',true);
    // await prefs.setBool('safeMobile',true);
    if (prefs.getBool('myPosition') != null) {
      _myPosition = prefs.getBool('myPosition');
    }
    if (prefs.getBool('testingCenters') != null) {
      _testingCenters = prefs.getBool('testingCenters');
    }
    if (prefs.getBool('infectedMobiles') != null) {
      _infectedMobiles = prefs.getBool('infectedMobiles');
    }
    if (prefs.getBool('contacts') != null) {
      _contacts = prefs.getBool('contacts');
    }
    if (prefs.getBool('safeMobile') != null) {
      _safeMobile = prefs.getBool('safeMobile');
    }
  }

  Future<void> setCheckboxes() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('myPosition', _myPosition);
    await prefs.setBool('testingCenters', _testingCenters);
    await prefs.setBool('infectedMobiles', _infectedMobiles);
    await prefs.setBool('contacts', _contacts);
    await prefs.setBool('safeMobile', _safeMobile);
    setState(() {});
  }

  Widget _body() {
    return Column(
      children: <Widget>[
        new Row(
          children: [
            Expanded(
              child: new CheckboxListTile(
                title: new Text('My Location'),
                value: _myPosition,
                onChanged: (bool value) async {
                  _myPosition = value;
                  await setCheckboxes();
                },
              ),
            ),
          ],
        ),
        new Row(
          children: [
            Expanded(
              child: new CheckboxListTile(
                title: new Text('Testing Centers'),
                value: _testingCenters,
                onChanged: (bool value) async {
                  _testingCenters = value;
                  await setCheckboxes();
                },
              ),
            ),
          ],
        ),
        new Row(
          children: [
            Expanded(
              child: new CheckboxListTile(
                title: new Text('Infected Mobiles'),
                value: _infectedMobiles,
                onChanged: (bool value) async {
                  _infectedMobiles = value;
                  await setCheckboxes();
                },
              ),
            ),
          ],
        ),
        new Row(
          children: [
            Expanded(
              child: new CheckboxListTile(
                title: new Text('Contacts'),
                value: _contacts,
                onChanged: (bool value) async {
                  _contacts = value;
                  await setCheckboxes();
                },
              ),
            ),
          ],
        ),
        new Row(
          children: [
            Expanded(
              child: new CheckboxListTile(
                title: new Text('Safe Mobiles'),
                value: _safeMobile,
                onChanged: (bool value) async {
                  _safeMobile = value;
                  await setCheckboxes();
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  void backButton() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        top: true,
        bottom: true,
        child: WillPopScope(
          onWillPop: backButton,
          child: Scaffold(
            appBar: AppBar(
              leading: BackButton(
                onPressed: backButton,
              ),
              title: Text('Marker Filter'),
              centerTitle: true,
              backgroundColor: Colors.blue,
            ),
            drawer: buildDrawer(context, FilterPage.route),
            body: _body(),
          ),
        ),
      ),
    );
  }
}
