import 'package:contact_tracing/services/badgeservices.dart';
import 'package:flutter/material.dart';

class NotificationBadgeProvider with ChangeNotifier {
  int _badgeNumber = BadgeServices.number;

  int get badgeNumber => _badgeNumber;

  void setBadgeNumber({required int badgeNumber}) {
    _badgeNumber = badgeNumber;
    notifyListeners();
  }
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