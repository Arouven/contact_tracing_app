import 'dart:convert';

import 'package:contact_tracing/models/message.dart';
import 'package:contact_tracing/services/badgeservices.dart';
import 'package:contact_tracing/services/databaseServices.dart';
import 'package:contact_tracing/services/notification.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import '../../widgets/drawer.dart';
import 'package:firebase_database/firebase_database.dart';

//FirebaseDatabase database = FirebaseDatabase.instance;

class NotificationsPage extends StatefulWidget {
  static const String route = '/notifications';

  @override
  _NotificationsPageState createState() {
    return _NotificationsPageState();
  }
}

List<Message> messageList = [];
String path = "notification/+23057775794/";

class _NotificationsPageState extends State<NotificationsPage> {
  bool _isLoading = true;
  @override
  void initState() {
    //FlutterBackgroundService().sendData({"action": "updateBadge"});
    getListofMessages().then((value) => setState(() {}));
    updateListofMessages();
    super.initState();
  }

  Future getListofMessages() async {
    setState(() {
      _isLoading = true;
    });
    DatabaseReference ref = FirebaseDatabase.instance.ref(path);
    // Get the data once
    DatabaseEvent event = await ref.once();

// Print the data of the snapshot
    print(event.snapshot.value); // { "name": "John" }
    DataSnapshot snapshot = event.snapshot; // DataSnapshot
    Map message = snapshot.value as Map;
    messageList.clear();
    setState(() {
      message.forEach((key, value) {
        messageList.add(
          new Message(
            id: key,
            title: value['title'],
            body: value['body'],
            read: value['read'],
            timestamp: value['timestamp'],
          ),
        );
      });
      _isLoading = false;
    });
  }

  updateListofMessages() {
    DatabaseReference ref = FirebaseDatabase.instance.ref(path);
// Get the Stream
    Stream<DatabaseEvent> stream = ref.onValue;

// Subscribe to the stream!
    stream.listen((DatabaseEvent event) {
      DataSnapshot snapshot = event.snapshot; // DataSnapshot
      Map message = snapshot.value as Map;
      messageList.clear();
      setState(() {
        message.forEach((key, value) {
          messageList.add(
            new Message(
              id: key,
              title: value['title'],
              body: value['body'],
              read: value['read'],
              timestamp: value['timestamp'],
            ),
          );
        });
      });
    });
  }

  Widget _body() {
    if (_isLoading == true) {
      return Center(child: CircularProgressIndicator());
    } else {
      return Scrollbar(
        child: ListView.builder(
          itemCount: messageList.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              leading: Icon(Icons.email),
              title: Text(
                messageList[index].title,
                style: (messageList[index].read)
                    ? null
                    : TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
              ),
              trailing: (messageList[index].read)
                  ? null
                  : Icon(
                      Icons.brightness_1,
                      size: 9.0,
                      color: Colors.red,
                    ),
              onTap: () async {
                if (messageList[index].read) {
                } else {
                  await DatabaseServices().markRead(
                    message: messageList[index],
                    path: path,
                  );
                  BadgeServices.number = BadgeServices.number - 1;
                  BadgeServices.updateAppBadge();
                }
                setState(() {
                  print(messageList[index].id);
                });
              },
            );
          },
        ),
      );
    }
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
