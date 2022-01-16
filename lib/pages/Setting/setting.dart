import 'package:connectivity/connectivity.dart';
import 'package:contact_tracing/providers/thememanager.dart';
import 'package:contact_tracing/services/globals.dart';
import 'package:contact_tracing/widgets/commonWidgets.dart';
import 'package:contact_tracing/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:provider/provider.dart';

int timeToUploadPerMinute = 6; //[1, 2, 6, 12]

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
  //bool _isDarkMode = false;
  late var _subscription;
  bool _internetConnection = true;

  Future _checkServices() async {
    var action = await GlobalVariables.getForegroundServices();
    if (action != true) {
      _isForground = false;
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
    //await GlobalVariables.setForegroundServices(showServices: !hide);
  }

  Future _getNotifier() async {
    return await GlobalVariables.getNotifier();
  }

  Future _getusermail() async {
    return await GlobalVariables.getEmail();
  }

  // Future _getDarkMode() async {
  //   try {
  //     if (await GlobalVariables.getDarkTheme() == true) {
  //       _isDarkMode = true;
  //     } else {
  //       _isDarkMode = false;
  //     }
  //   } catch (e) {
  //     _isDarkMode = false;
  //   }
  // }

  @override
  void initState() {
    _subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      print(result);
      if (result == ConnectivityResult.none) {
        setState(() {
          _internetConnection = false;
        });
      } else {
        setState(() {
          _internetConnection = true;
        });
      }
    });
    _checkServices().whenComplete(() {
      //  _getDarkMode().whenComplete(() {
      _getNotifier().then((notifier) {
        _getusermail().then((usermail) {
          setState(() {
            _notifier = notifier;
            _usermail = usermail;
            _isLoading = false;
          });
        });
      });
      //  });
    });

    super.initState();
  }

  _body() {
    if (_internetConnection == false) {
      return Aesthetic.displayNoConnection();
    } else {
      if (_isLoading) {
        //loading
        return Aesthetic.displayCircle();
      } else {
        return _listOfSettings();
      }
    }
  }

  _listOfSettings() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final provider = Provider.of<ThemeProvider>(context, listen: false);
    if (GlobalVariables.emailProp == '') {
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
                    setState(() {
                      themeProvider.isDarkMode;
                      print("should change");
                    });
                    // setState(() {
                    //   _isDarkMode = value;
                    // });
                  },
                  // activeTrackColor: Theme.of(context).backgroundColor,
                  // activeColor: Theme.of(context).accentColor,
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
                  //  activeTrackColor: Theme.of(context).backgroundColor,
                  //activeColor: Theme.of(context).accentColor,
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
                DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    items: <int>[1, 2, 6, 12].map((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text(value.toString()),
                      );
                    }).toList(),
                    isExpanded: false,
                    value: timeToUploadPerMinute,
                    onChanged: (value) {
                      setState(() {
                        if (value != null) {
                          timeToUploadPerMinute = value;
                        }
                      });
                    },
                  ),
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
          drawer: buildDrawer(context, SettingPage.route),
          body: _body(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  void deactivate() {
    _subscription.cancel();
    super.deactivate();
  }
}
