import 'package:contact_tracing/providers/thememanager.dart';
import 'package:contact_tracing/services/globals.dart';
import 'package:contact_tracing/widgets/commonWidgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:provider/provider.dart';
import '../../widgets/drawer.dart';

int timeToUploadPerMinute = 2;

class SettingPage extends StatefulWidget {
  static const String route = '/setting';

  @override
  _SettingPageState createState() {
    return _SettingPageState();
  }
}

class _SettingPageState extends State<SettingPage> {
  bool _isForground = false;
  bool _notifier = false;
  late String _usermail = '';
  bool _isLoading = true;

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

  Future _getNotifier() async {
    return await GlobalVariables.getNotifier();
  }

  Future _getusermail() async {
    return await GlobalVariables.getEmail();
  }

  @override
  void initState() {
    _checkServices().whenComplete(() {
      _getNotifier().then((notifier) {
        _getusermail().then((usermail) {
          setState(() {
            _notifier = notifier;
            _usermail = usermail;
            _isLoading = false;
          });
        });
      });
    });

    super.initState();
  }

  _body() {
    if (_isLoading) {
      //loading
      return Aesthetic.displayCircle();
    } else {
      return _listOfSettings();
    }
  }

  _listOfSettings() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final provider = Provider.of<ThemeProvider>(context, listen: false);
    if (_usermail == '') {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            height: 40.0,
            padding: EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Text(
                    'Dark Mode:',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    // style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                Switch.adaptive(
                  value: themeProvider.isDarkMode,
                  onChanged: (value) async {
                    provider.toggleTheme(value);
                  },
                  activeTrackColor: Theme.of(context).backgroundColor,
                  activeColor: Theme.of(context).accentColor,
                ),
              ],
            ),
          ),
        ],
      );
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            height: 40.0,
            padding: EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Text(
                    'Dark Mode:',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    // style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                Switch.adaptive(
                  value: themeProvider.isDarkMode,
                  onChanged: (value) async {
                    provider.toggleTheme(value);
                  },
                  activeTrackColor: Theme.of(context).backgroundColor,
                  activeColor: Theme.of(context).accentColor,
                ),
              ],
            ),
          ),
          Container(
            height: 40.0,
            padding: EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Text(
                    'Hide Services:',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    //    style: Theme.of(context).textTheme.headline6,
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
                  activeTrackColor: Theme.of(context).backgroundColor,
                  activeColor: Theme.of(context).accentColor,
                ),
              ],
            ),
          ),
          Container(
            height: 40.0,
            padding: EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Text(
                    'Notify when upload:',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Switch(
                  value: _notifier,
                  onChanged: (value) async {
                    await GlobalVariables.setNotifier(notifier: value);
                    setState(() {
                      _notifier = value;
                    });
                  },
                  activeTrackColor: Theme.of(context).backgroundColor,
                  activeColor: Theme.of(context).accentColor,
                ),
              ],
            ),
          ),
          Container(
            height: 40.0,
            padding: EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Text(
                    'Upload frequency(hrs):',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                DropdownButton<int>(
                  items: <int>[1, 2, 6, 12].map((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text(timeToUploadPerMinute.toString()),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      if (value != null) {
                        timeToUploadPerMinute = value;
                      }
                    });
                  },
                )
              ],
            ),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    //var moblies = ApiProfile.getProfiles();
    return Container(
      // color: Colors.white,
      child: SafeArea(
        top: true,
        bottom: true,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Settings'),
            centerTitle: true,
            //backgroundColor: Colors.blue,
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
