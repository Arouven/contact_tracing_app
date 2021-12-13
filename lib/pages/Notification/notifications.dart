import 'package:contact_tracing/models/message.dart';
import 'package:contact_tracing/services/apiNotification.dart';
import 'package:contact_tracing/services/notification.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
  var _messageList = [];
  @override
  void initState() {
    aa().whenComplete(() => setState(() {}));
    openAppMessage();
    super.initState();
  }

  Future aa() async {
    _messageList = await ApiMessage.getMessages();
  }

  openAppMessage() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Parse the message received
      setState(() {
        print('QQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQqqq');
        _messageList = ApiMessage.getMessages();
      });
    });
  }

  Widget _body() {
    return Scrollbar(
        child: ListView.builder(
            itemCount: _messageList == null ? 0 : _messageList.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(_messageList[index].title),
              );
            }));
    // widgets.add(ListTile(
    //   title: Text('title'),
    // ));
    //return null;
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
          body: _body(),
        ),
      ),
    );
  }
}
