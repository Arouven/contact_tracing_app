import 'package:contact_tracing/services/globals.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import '../../widgets/drawer.dart';

class SettingPage extends StatefulWidget {
  static const String route = '/setting';

  @override
  _SettingPageState createState() {
    return _SettingPageState();
  }
}

class _SettingPageState extends State<SettingPage> {
  bool _isForground = false;

  Future _checkServices() async {
    var action = await GlobalVariables.getBackgroundServices();
    if (action == 'setAsBackground') {
      _isForground = false;
    } else if (action == "setAsForeground") {
      _isForground = true;
    }
  }

  Future _setServices(bool hide) async {
    String service;
    if (hide == true) {
      service = "setAsBackground";
    } else {
      service = "setAsForeground";
    }
    FlutterBackgroundService().sendData({"action": service});
    await GlobalVariables.setBackgroundServices(backgroundServices: service);
  }

  @override
  void initState() {
    _checkServices().whenComplete(() => setState(() {}));
    super.initState();
  }

  _body() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Text(
                  'Hide Services:',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              Switch(
                value: _isForground,
                onChanged: (value) async {
                  await _setServices(value);
                  setState(() {
                    _isForground = value;
                  });
                },
                // activeTrackColor: Colors.lightGreenAccent,
                //activeColor: Colors.green,
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    //var moblies = ApiProfile.getProfiles();
    return Container(
      color: Colors.white,
      child: SafeArea(
        top: true,
        bottom: true,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Settings'),
            centerTitle: true,
            backgroundColor: Colors.blue,
          ),
          drawer: buildDrawer(
            context,
            SettingPage.route,
          ),
          body: _body(),
        ),
      ),
    );
  }
}
