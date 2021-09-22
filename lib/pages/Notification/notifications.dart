import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../widgets/drawer.dart';

class NotificationsPage extends StatefulWidget {
  static const String route = '/notifications';

  @override
  _NotificationsPageState createState() {
    return _NotificationsPageState();
  }
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //var moblies = ApiNotification.getNotifications();
    return Container(
      color: Colors.white,
      child: SafeArea(
        top: true,
        bottom: true,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Notifications'),
            centerTitle: true,
            backgroundColor: Colors.blue,
          ),
          drawer: buildDrawer(context, NotificationsPage.route),
          //body:
        ),
      ),
    );
  }
}
