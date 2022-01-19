import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:contact_tracing/main.dart';
import 'package:contact_tracing/models/message.dart';
import 'package:contact_tracing/pages/Mobile/mobiles.dart';
import 'package:contact_tracing/pages/Notification/singlenotification.dart';
import 'package:contact_tracing/providers/notificationbadgemanager.dart';
import 'package:contact_tracing/services/badgeservices.dart';
import 'package:contact_tracing/services/globals.dart';
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
  late var _firebaseListener = null;
  bool _internetConnection = true;
  // late StreamSubscription _stream;

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
        _problemWithFirebase = true;
        _isLoading = false;
      });
      print(e.toString());
    }
  }

  void _startListening() {
    if (path != "") {
      print('listening for changes from firebase started');
      DatabaseReference ref = FirebaseDatabase.instance.ref(path);
// Get the Stream
      Stream<DatabaseEvent> stream = ref.onValue;

// Subscribe to the stream!
      _firebaseListener = stream.listen((DatabaseEvent event) async {
        try {
          print('change detected updating badges in ');
          await BadgeServices.updateBadge();
          int badgenumber = await GlobalVariables.getBadgeNumber();
          print(badgenumber.toString());
          print('change detected updating badges');
          Provider.of<NotificationBadgeProvider>(context, listen: false)
              .providerSetBadgeNumber(badgeNumber: (badgenumber));
        } catch (e) {
          print(e.toString());
        }
      });
    }
  }

  void _updateListofMessages() {
    if (path != "") {
      DatabaseReference ref = FirebaseDatabase.instance.ref(path);
// Get the Stream
      Stream<DatabaseEvent> stream = ref.onValue;

// Subscribe to the stream!
      _firebaseListener = stream.listen((DatabaseEvent event) async {
        try {
          DataSnapshot snapshot = event.snapshot; // DataSnapshot
          Map message = snapshot.value as Map;
          messageList.clear();
          setState(() {
            if (message != null) {
              message.forEach((key, value) {
                messageList.add(
                  new Message(
                    id: key,
                    title: value['title'] as String,
                    body: value['body'] as String,
                    read: value['read'] as bool,
                    timestamp: value['timestamp'] as int,
                  ),
                );
              });
            }
            print('updated list builder');
            _problemWithFirebase = false;
            _isLoading = false;
          });
          //  });
        } catch (e) {
          setState(() {
            _problemWithFirebase = true;
            _isLoading = false;
          });
          print(e.toString());
        }
      });
    }
  }

  Widget _body() {
    if (_internetConnection == false) {
      return Aesthetic.displayNoConnection();
    } else if (_problemWithFirebase == true) {
      return Scrollbar(
        child: RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(
                  Duration(seconds: 2)); //to allow circular loading
              await _getListofMessages();
            },
            child: Aesthetic.displayProblemFirebase()),
      );
    } else {
      if (_isLoading != false) {
        return Aesthetic.displayCircle();
      } else {
        return Scrollbar(
          child: RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(
                  Duration(seconds: 2)); //to allow circular loading
              await _getListofMessages();
            },
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
                        builder: (BuildContext context) =>
                            SingleNotificationPage(
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
          ),
        );
      }
    }
  }

  Future _updateWidget() async {
    int badgenumber = await GlobalVariables.getBadgeNumber();
    print(badgenumber.toString());
    Provider.of<NotificationBadgeProvider>(context, listen: false)
        .providerSetBadgeNumber(badgeNumber: (badgenumber));
  }

  @override
  void initState() {
    _updateWidget().whenComplete(() async {
      await generatePath();
    });
    try {
      _subscription = Connectivity()
          .onConnectivityChanged
          .listen((ConnectivityResult result) {
        print(result.toString());
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
      checkMobileNumber(context: context).whenComplete(() {});
      _getListofMessages().whenComplete(() {
        _startListening();
        _updateListofMessages();
      });

      //  _updateListofMessages();
    } catch (e) {
      print(e.toString());
    }
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
    _subscription.cancel();
    // if (_firebaseListener != null) {
    //   _firebaseListener.cancel();
    // }
    super.dispose();
  }

  @override
  void deactivate() {
    _subscription.cancel();
    // if (_firebaseListener != null) {
    //   _firebaseListener.cancel();
    // }
    super.deactivate();
  }
}
