import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:contact_tracing/main.dart';
import 'package:contact_tracing/models/message.dart';
import 'package:contact_tracing/pages/Notification/singlenotification.dart';
import 'package:contact_tracing/providers/notificationbadgemanager.dart';
import 'package:contact_tracing/widgets/commonWidgets.dart';
import 'package:contact_tracing/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:provider/provider.dart';

class NotificationsPage extends StatefulWidget {
  static const String route = '/notifications';

  @override
  _NotificationsPageState createState() {
    return _NotificationsPageState();
  }
}

class _NotificationsPageState extends State<NotificationsPage> {
  bool _isLoading = true;
  bool _problemWithFirebase = false;
  List<Message> messageList = [];
  late var _subscription;
  late var _firebaseListener;
  bool _internetConnection = true;
  late StreamSubscription _stream;

  Future _getListofMessages() async {
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
        _problemWithFirebase = false;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _problemWithFirebase = false;
        _isLoading = false;
      });
      print(e);
    }
  }

  void _updateListofMessages() {
    if (path != "") {
      DatabaseReference ref = FirebaseDatabase.instance.ref(path);
// Get the Stream
      Stream<DatabaseEvent> stream = ref.onValue;

// Subscribe to the stream!
      _stream = stream.listen((DatabaseEvent event) {
        try {
          print("listening in notification page");
          DataSnapshot snapshot = event.snapshot; // DataSnapshot
          Map message = snapshot.value as Map;
          messageList.clear();

          int unreadmsg = 0;

          setState(() async {
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

            BadgeServices.number = unreadmsg;
            await BadgeServices.updateBadge();
            print(BadgeServices.number);
            Provider.of<NotificationBadgeProvider>(context, listen: false)
                .providerSetBadgeNumber(badgeNumber: (BadgeServices.number));
            _problemWithFirebase = true;
            _isLoading = false;
          });
        } catch (e) {
          setState(() {
            _problemWithFirebase = false;
            _isLoading = false;
          });
          print(e);
        }
      });
    }
  }

  Widget _body() {
    if (_internetConnection == false) {
      return Aesthetic.displayNoConnection();
    } else if (_problemWithFirebase == true) {
      return Aesthetic.displayProblemFirebase();
    } else {
      if (_isLoading != false) {
        return Aesthetic.displayCircle();
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
  }

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

  @override
  void dispose() {
    _stream.cancel();
    _subscription.cancel();
    _firebaseListener.cancel();
    super.dispose();
  }

  @override
  void deactivate() {
    _subscription.cancel();
    _firebaseListener.cancel();
    super.deactivate();
  }
}
