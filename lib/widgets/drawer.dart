import 'package:contact_tracing/pages/Login/login.dart';
import 'package:contact_tracing/pages/Mobile/mobiles.dart';
import 'package:contact_tracing/pages/Notification/notifications.dart';
import 'package:contact_tracing/pages/Profile/profile.dart';
import 'package:flutter/material.dart';
import '../pages/Location/live_geolocator.dart';
import '../pages/Login/login.dart';

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

Drawer buildDrawer(BuildContext context, String currentRoute) {
  return Drawer(
    child: ListView(
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
          const Text('Login/Register'),
          const Icon(Icons.group),
          LoginPage.route,
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
          const Icon(Icons.notifications),
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
      ],
    ),
  );
}
