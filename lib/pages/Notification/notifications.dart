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
import 'package:firebase_database/ui/firebase_animated_list.dart';
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
  //bool _isLoading = true;
  //bool _problemWithFirebase = false;
  //List<Message> messageList = [];
  late var _subscription;
  late var _firebaseListener = null;
  bool _internetConnection = true;
  // late StreamSubscription _stream;

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

//   void _updateListofMessages() {
//     if (path != "") {
//       DatabaseReference ref = FirebaseDatabase.instance.ref(path);
// // Get the Stream
//       Stream<DatabaseEvent> stream = ref.onValue;

// // Subscribe to the stream!
//       _firebaseListener = stream.listen((DatabaseEvent event) async {
//         try {
//           DataSnapshot snapshot = event.snapshot; // DataSnapshot
//           Map message = snapshot.value as Map;
//           messageList.clear();
//           setState(() {
//             if (message != null) {
//               message.forEach((key, value) {
//                 messageList.add(
//                   new Message(
//                     id: key,
//                     title: value['title'] as String,
//                     body: value['body'] as String,
//                     read: value['read'] as bool,
//                     timestamp: value['timestamp'] as int,
//                   ),
//                 );
//               });
//             }
//             print('updated list builder');
//             _problemWithFirebase = false;
//             _isLoading = false;
//           });
//           //  });
//         } catch (e) {
//           setState(() {
//             _problemWithFirebase = true;
//             _isLoading = false;
//           });
//           print(e.toString());
//         }
//       });
//     }
//   }

  //  ListView.builder(
  //   itemCount: messageList.length,
  //   itemBuilder: (BuildContext context, int index) {
  //     return ListTile(
  //       leading: Icon(Icons.email),
  //       title: Text(
  //         messageList[index].title,
  //         style: (messageList[index].read != false)
  //             ? null
  //             : TextStyle(
  //                 fontWeight: FontWeight.bold,
  //               ),
  //       ),
  //       trailing: (messageList[index].read != false)
  //           ? null
  //           : Icon(
  //               Icons.brightness_1,
  //               size: 9.0,
  //               color: Colors.red,
  //             ),
  //       onTap: () async {
  //         var msg = messageList[index];
  //         await Navigator.of(context).push(
  //           MaterialPageRoute(
  //             builder: (BuildContext context) =>
  //                 SingleNotificationPage(
  //               message: msg,
  //             ),
  //           ),
  //         );
  //         setState(() {
  //           msg.read = true;
  //         });
  //       },
  //     );
  //   },
  // ),

  Widget _body() {
    if (_internetConnection == false) {
      return Aesthetic.displayNoConnection();
      // } else if (_problemWithFirebase == true) {
      //   return Aesthetic.displayProblemFirebase();
      // } else {
      //   if (_isLoading != false) {
      //     return Aesthetic.displayCircle();
    } else {
      var ref = FirebaseDatabase.instance.ref(path);
      return FirebaseAnimatedList(
        shrinkWrap: true,
        physics: AlwaysScrollableScrollPhysics(),
        reverse: true,
        query: ref.orderByChild('timestamp'), //orderBy('timestamp'),
        duration: Duration(seconds: 2),
        itemBuilder: (context, snapshot, animation, index) {
          var nextMessage;
          if (snapshot.value == null) {
            ref.orderByChild('timestamp').once().then((event) {
              nextMessage = (Message.fromRTDB(event.snapshot));
            });

            //   _problemWithFirebase = false;
            //   _isLoading = false;
          } else {
            nextMessage = (Message.fromRTDB(snapshot));
          }

          // Map message = snapshot.value as Map;
          // messageList.clear();
          // setState(() {
          //   if (message != null) {
          //     message.forEach((key, value) {
          //       messageList.add(
          //         new Message(
          //           id: key,
          //           title: value['title'] as String,
          //           body: value['body'] as String,
          //           read: value['read'] as bool,
          //           timestamp: value['timestamp'] as int,
          //         ),
          //       );
          //     });
          //   }
          //   print('updated list builder');

          // });

          return SlideTransition(
            position: Tween<Offset>(
              begin: Offset(1, 0),
              end: Offset(0, 0),
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.bounceInOut,
              reverseCurve: Curves.bounceIn,
            )),
            child: ListTile(
              leading: Icon(Icons.email),
              title: Text(
                nextMessage.title,
                style: (nextMessage.read != false)
                    ? null
                    : TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
              ),
              trailing: (nextMessage.read != false)
                  ? null
                  : Icon(
                      Icons.brightness_1,
                      size: 9.0,
                      color: Colors.red,
                    ),
              onTap: () async {
                var msg = nextMessage;
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
              },
            ),
          );
        },
      );
      //}
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
      // _getListofMessages().whenComplete(() {
      _startListening();
      // _updateListofMessages();
      //  });
    } catch (e) {
      print(e.toString());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
