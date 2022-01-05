import 'package:contact_tracing/main.dart';
import 'package:contact_tracing/models/message.dart';
import 'package:contact_tracing/pages/Notification/singlenotification.dart';
import 'package:contact_tracing/services/badgeservices.dart';
import 'package:contact_tracing/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class NotificationsPage extends StatefulWidget {
  static const String route = '/notifications';

  @override
  _NotificationsPageState createState() {
    return _NotificationsPageState();
  }
}

class _NotificationsPageState extends State<NotificationsPage> {
  bool _isLoading = true;
  List<Message> messageList = [];

  Future _getListofMessages() async {
    setState(() {
      _isLoading = true;
    });
    try {
      DatabaseReference ref = FirebaseDatabase.instance.ref(path);
      // Get the data once
      DatabaseEvent event = await ref.once();

// Print the data of the snapshot
      print(event.snapshot.value); // { "name": "John" }
      DataSnapshot snapshot = event.snapshot; // DataSnapshot
      Map message = snapshot.value as Map;
      messageList.clear();
      setState(() {
        if (message != null) {
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
        }
        _isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  void _updateListofMessages() {
    DatabaseReference ref = FirebaseDatabase.instance.ref(path);
// Get the Stream
    Stream<DatabaseEvent> stream = ref.onValue;

// Subscribe to the stream!
    stream.listen((DatabaseEvent event) {
      try {
        DataSnapshot snapshot = event.snapshot; // DataSnapshot
        Map message = snapshot.value as Map;
        messageList.clear();
        int unreadmsg = 0;
        setState(() {
          if (message != null) {
            message.forEach((key, value) {
              if (value['read'] == false) {
                unreadmsg += 1;
              }
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
          }
        });
        setState(() async {
          BadgeServices.number = unreadmsg;
          await BadgeServices.updateBadge();
          print(BadgeServices.number);
          _isLoading = false;
        });
      } catch (e) {
        print(e);
      }
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
                style: (messageList[index].read != false)
                    ? null
                    : TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
              ),
              trailing: (messageList[index].read != false)
                  ? null
                  : Icon(
                      Icons.brightness_1,
                      size: 9.0,
                      color: Colors.red,
                    ),
              onTap: () async {
                var msg = messageList[index];
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => SingleNotificationPage(
                      message: msg,
                    ),
                  ),
                );
                setState(() {
                  msg.read = true;
                });
                // Navigator.of(context).pushReplacement(
                //   MaterialPageRoute(
                //     builder: (BuildContext context) => SingleNotificationPage(
                //       message: messageList[index],
                //     ),
                //   ),
                // );
              },
            );
          },
        ),
      );
    }
  }

  @override
  void initState() {
    _getListofMessages().whenComplete(() => setState(() {}));
    _updateListofMessages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //var moblies = ApiNotification.getNotifications();
    return Container(
      // color: Colors.white,
      child: SafeArea(
        top: true,
        bottom: true,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Notifications'),
            centerTitle: true,
            // backgroundColor: Colors.blue,
          ),
          drawer: buildDrawer(context, NotificationsPage.route),
          body: _body(),
        ),
      ),
    );
  }
}
