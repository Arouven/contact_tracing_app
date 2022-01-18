import 'dart:async';
import 'package:contact_tracing/main.dart';
import 'package:contact_tracing/services/badgeservices.dart';
import 'package:contact_tracing/services/globals.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class NotificationBadgeProvider with ChangeNotifier {
  int _badgeNumber = 0;

  int get badgeNumber => _badgeNumber;

//   void providerListenToDbNotif() {
//     print('providerListento db notif');
//     print("$path");
//     print(_badgeNumber);
//     if (path != "") {
//       print('listening for new child from firebase');
//       DatabaseReference ref = FirebaseDatabase.instance.ref(path);
// // Get the Stream
//       Stream<DatabaseEvent> stream = ref.onValue;

// // Subscribe to the stream!
//       _stream = stream.listen((DatabaseEvent event) async {
//         try {
//           DataSnapshot snapshot = event.snapshot; // DataSnapshot
//           print('abcde');
//           //{timestamp: 1642240673, body: You may be infected practice self-isolation and perform a test, title: In Contact, read: true}
//           if (snapshot.value != null) {
//             final json = snapshot.value as Map;
//             int badge = 0;
//             json.forEach((key, value) {
//               if (json['read'] == false) {
//                 badge = badge + 1;
//               }
//             });
//             BadgeServices.number = _badgeNumber = badge;
//             print(json['read']);
//             BadgeServices.updateBadge();

//             notifyListeners();
//           }
//         } catch (e) {
//           print('error in provider');
//           print(e);
//         }
//       });
//     }
//   }

  void providerSetBadgeNumber({required int badgeNumber}) async {
    print("providerSetBadgeNumber badge $badgeNumber");
    print("providerSetBadgeNumber badge $_badgeNumber");
    _badgeNumber = badgeNumber;
    print("providerSetBadgeNumber badge $_badgeNumber");
    // await GlobalVariables.setBadgeNumber(badgeNumber: badgeNumber);
    notifyListeners();
  }

  // @override
  // void dispose() {
  //   _stream.cancel();
  //   super.dispose();
  // }
}
  // ChangeNotifierProvider<NotificationBadgeProvider>(
  //           create: (_) => new NotificationBadgeProvider(),
  //           builder: (context, _) {
  //             final notificationBadgeProvider =
  //                 Provider.of<NotificationBadgeProvider>(context);
  //             notificationBadgeProvider.setBadgeNumber(badgeNumber: 12);
  //           });




  //             final notificationBadgeProvider =
  //                 Provider.of<NotificationBadgeProvider>(context);
    // final provider = Provider.of<NotificationBadgeProvider>(context, listen: false);//forcing rebuilding of widgets
    //  provider.setBadgeNumber(123);
    //                 setState(() {
    //                   notificationBadgeProvider.badgeNumber;
    //                   print("should change");
    //                 });

    // StreamBuilder(
    //             stream: Connectivity().onConnectivityChanged,
    //             builder: (BuildContext context,
    //                 AsyncSnapshot<ConnectivityResult> snapshot) {
    //               if (snapshot != null &&
    //                   snapshot.hasData &&
    //                   snapshot.data != ConnectivityResult.none) {
    //                 return Home_Screen();
    //               } else {
    //                 return NoConnex();
    //               }
    //             },
    //           )

// subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {         print(result);
//         if (result == ConnectivityResult.none) {
//       return;}
// });
 