import 'package:contact_tracing/providers/thememanager.dart';
import 'package:contact_tracing/services/globals.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:provider/provider.dart';
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
  bool _notifier = false;

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

  @override
  void initState() {
    _checkServices().whenComplete(() => setState(() {}));
    _getNotifier().then((value) => setState(() {
          _notifier = value;
        }));
    super.initState();
  }

  _body() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final provider = Provider.of<ThemeProvider>(context, listen: false);
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
      ],
    );
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
