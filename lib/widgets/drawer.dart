import 'package:badges/badges.dart';
import 'package:contact_tracing/pages/Location/live_geolocator.dart';
import 'package:contact_tracing/pages/Login/login.dart';
import 'package:contact_tracing/pages/Mobile/mobiles.dart';
import 'package:contact_tracing/pages/Notification/notifications.dart';
import 'package:contact_tracing/pages/Profile/profile.dart';
import 'package:contact_tracing/pages/Setting/setting.dart';
import 'package:contact_tracing/providers/notificationbadgemanager.dart';
import 'package:contact_tracing/services/badgeservices.dart';
import 'package:contact_tracing/services/globals.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Widget? buildDrawer(var context, var route) {
//   return ChangeNotifierProvider<NotificationBadgeProvider>(
//     create: (context) => NotificationBadgeProvider(),
//     builder: (context, __) =>
//     DrawerSide(currentRoutes: route),
//   );
// }
Widget? buildDrawer(var context, var route) {
  return DrawerSide(currentRoutes: route);
}

class DrawerSide extends StatefulWidget {
  String currentRoutes;
  DrawerSide({required this.currentRoutes});
  @override
  _DrawerSideState createState() {
    return _DrawerSideState();
  }
}

class _DrawerSideState extends State<DrawerSide> {
  @override
  Widget build(BuildContext context) {
    var currentRoute = widget.currentRoutes;
    Widget _buildMenuItem(BuildContext context, Widget title, Widget leading,
        String routeName, String currentRoute) {
      var isSelected = routeName == currentRoute;

      return ListTile(
        title: title,
        leading: leading,
        selected: isSelected,
        onTap: () {
          if (isSelected) {
            Navigator.pop(context);
          } else {
            Navigator.pushReplacementNamed(context, routeName);
          }
        },
      );
    }

    // Widget notifBadge() {
    //   // final np = Provider.of<NotificationBadgeProvider>(context);

    //   // print('>>>>>>>>>>>>>>>>>>>> REBUILD');
    //   // print(np.badgeNumber);
    //   // print(BadgeServices.number);

    //   // if (np.badgeNumber > 0) {
    //   //   print(np.badgeNumber);
    //   //   return (Badge(
    //   //     badgeContent: Text(
    //   //       (np.badgeNumber).toString(),
    //   //       style: TextStyle(fontSize: 8.0),
    //   //     ),
    //   //     child: Icon(Icons.notifications),
    //   //   ));
    //   // } else {
    //   //   return (Icon(Icons.notifications));
    //   // }

    //   return Consumer<NotificationBadgeProvider>(
    //     builder: (context, np, child) {
    //       print('>>>>>>>>>>>>>>>>>>>> REBUILD');
    //       print(np.badgeNumber);
    //       print(BadgeServices.number);
    //       if (np.badgeNumber > 0) {
    //         print(np.badgeNumber);
    //         return (Badge(
    //           badgeContent: Text(
    //             (np.badgeNumber).toString(),
    //             style: TextStyle(fontSize: 8.0),
    //           ),
    //           child: Icon(Icons.notifications),
    //         ));
    //       } else {
    //         return (Icon(Icons.notifications));
    //       }
    //     },
    //   );
    // }
    Widget notificationWidget() {
      int bn = Provider.of<NotificationBadgeProvider>(context, listen: false)
          .badgeNumber;

      print('>>>>>>>>>>>>>>>>>>>> REBUILD');
      print(bn);
      print(BadgeServices.number);

      if (bn > 0) {
        print(BadgeServices.number);
        return (Badge(
          badgeContent: Text(
            (bn).toString(),
            style: TextStyle(fontSize: 8.0),
          ),
          child: Icon(Icons.notifications),
        ));
      } else {
        return (Icon(Icons.notifications));
      }

      // Consumer<NotificationBadgeProvider>(
      //               builder: (context, np, child) {
      //                 print('>>>>>>>>>>>>>>>>>>>> REBUILD');
      //                 print(np.badgeNumber);
      //                 print(BadgeServices.number);

      //                 if (BadgeServices.number > 0) {
      //                   print(BadgeServices.number);
      //                   return (Badge(
      //                     badgeContent: Text(
      //                       (BadgeServices.number).toString(),
      //                       style: TextStyle(fontSize: 8.0),
      //                     ),
      //                     child: Icon(Icons.notifications),
      //                   ));
      //                 } else {
      //                   return (Icon(Icons.notifications));
      //                 }
      //               },
      //             ),
    }

    // Drawer buildDrawer(BuildContext context, String currentRoute) {
    return Drawer(
      child: (GlobalVariables.emailProp == '')
          ? ListView(
              children: <Widget>[
                const DrawerHeader(
                  child: Center(
                    child: Text('Contact Tracing'),
                  ),
                ),
                _buildMenuItem(
                  context,
                  const Text('Login/Register'),
                  const Icon(Icons.group),
                  LoginPage.route,
                  currentRoute,
                ),
                _buildMenuItem(
                  context,
                  const Text('Setting'),
                  const Icon(Icons.settings),
                  SettingPage.route,
                  currentRoute,
                ),
              ],
            )
          : ListView(
              children: <Widget>[
                const DrawerHeader(
                  child: Center(
                    child: Text('Contact Tracing'),
                  ),
                ),
                _buildMenuItem(
                  context,
                  const Text('Home'),
                  const Icon(Icons.home),
                  LiveGeolocatorPage.route,
                  currentRoute,
                ),
                _buildMenuItem(
                  context,
                  const Text('Mobile'),
                  const Icon(Icons.devices),
                  MobilePage.route,
                  currentRoute,
                ),
                _buildMenuItem(
                  context,
                  const Text('Notifications'),
                  notificationWidget(),
                  NotificationsPage.route,
                  currentRoute,
                ),
                _buildMenuItem(
                  context,
                  const Text('Profile'),
                  const Icon(Icons.person),
                  ProfilePage.route,
                  currentRoute,
                ),
                _buildMenuItem(
                  context,
                  const Text('Setting'),
                  const Icon(Icons.settings),
                  SettingPage.route,
                  currentRoute,
                ),
              ],
            ),
    );
  }
}

// /// used to build the burger button
// /// return [ListTile]
// Widget _buildMenuItem(BuildContext context, Widget title, Widget leading,
//     String routeName, String currentRoute) {
//   var isSelected = routeName == currentRoute;

//   return ListTile(
//     title: title,
//     leading: leading,
//     selected: isSelected,
//     onTap: () {
//       if (isSelected) {
//         Navigator.pop(context);
//       } else {
//         Navigator.pushReplacementNamed(context, routeName);
//       }
//     },
//   );
// }

// /// draw the list of pages in the burgar
// Drawer buildDrawer(BuildContext context, String currentRoute) {
//   return Drawer(
//     child: (GlobalVariables.emailProp == '')
//         ? withLogin(
//             context,
//             currentRoute,
//           )
//         : withoutLogin(
//             context,
//             currentRoute,
//           ),
//   );
// }

// Widget withLogin(BuildContext context, String currentRoute) {
//   return ListView(
//     children: <Widget>[
//       const DrawerHeader(
//         child: Center(
//           child: Text('Contact Tracing'),
//         ),
//       ),
//       _buildMenuItem(
//         context,
//         const Text('Login/Register'),
//         const Icon(Icons.group),
//         LoginPage.route,
//         currentRoute,
//       ),
//       _buildMenuItem(
//         context,
//         const Text('Setting'),
//         const Icon(Icons.settings),
//         SettingPage.route,
//         currentRoute,
//       ),
//     ],
//   );
// }

// Widget withoutLogin(BuildContext context, String currentRoute) {
//   final notificationBadgeProvider =
//       Provider.of<NotificationBadgeProvider>(context);

//   notificationBadgeProvider.badgeNumber;

//   return ListView(
//     children: <Widget>[
//       const DrawerHeader(
//         child: Center(
//           child: Text('Contact Tracing'),
//         ),
//       ),
//       _buildMenuItem(
//         context,
//         const Text('Home'),
//         const Icon(Icons.home),
//         LiveGeolocatorPage.route,
//         currentRoute,
//       ),
//       _buildMenuItem(
//         context,
//         const Text('Mobile'),
//         const Icon(Icons.devices),
//         MobilePage.route,
//         currentRoute,
//       ),
//       _buildMenuItem(
//         context,
//         const Text('Notifications'),
//         notificationBadgeProvider.notifBadge(),
//         NotificationsPage.route,
//         currentRoute,
//       ),
//       _buildMenuItem(
//         context,
//         const Text('Profile'),
//         const Icon(Icons.person),
//         ProfilePage.route,
//         currentRoute,
//       ),
//       _buildMenuItem(
//         context,
//         const Text('Setting'),
//         const Icon(Icons.settings),
//         SettingPage.route,
//         currentRoute,
//       ),
//     ],
//   );
// }
