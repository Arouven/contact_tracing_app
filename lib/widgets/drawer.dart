import 'package:contact_tracing/pages/Location/live_geolocator.dart';
import 'package:contact_tracing/pages/Login/login.dart';
import 'package:contact_tracing/pages/Mobile/mobiles.dart';
import 'package:contact_tracing/pages/Notification/notifications.dart';
import 'package:contact_tracing/pages/Profile/profile.dart';
import 'package:contact_tracing/pages/Setting/setting.dart';
import 'package:contact_tracing/services/badgeservices.dart';
import 'package:contact_tracing/services/globals.dart';
import 'package:flutter/material.dart';

/// used to build the burger button
/// return [ListTile]
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

/// draw the list of pages in the burgar
Drawer buildDrawer(BuildContext context, String currentRoute) {
  return Drawer(
    child: (GlobalVariables.emailProp == '')
        ? withLogin(
            context,
            currentRoute,
          )
        : withoutLogin(
            context,
            currentRoute,
          ),
  );
}

Widget withLogin(BuildContext context, String currentRoute) {
  return ListView(
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
  );
}

Widget withoutLogin(BuildContext context, String currentRoute) {
  return ListView(
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
        BadgeServices.notificationBadge(),
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
  );
}
