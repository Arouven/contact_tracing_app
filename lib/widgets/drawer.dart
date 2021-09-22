import 'package:contact_tracing/pages/login.dart';
import 'package:contact_tracing/pages/Mobile/mobiles.dart';
import 'package:contact_tracing/pages/notifications.dart';
import 'package:contact_tracing/pages/profile.dart';
import 'package:flutter/material.dart';
import '../pages/live_geolocator.dart';
import '../pages/login.dart';

Widget _buildMenuItem(
    BuildContext context, Widget title, String routeName, String currentRoute) {
  var isSelected = routeName == currentRoute;

  return ListTile(
    title: title,
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
          LiveGeolocatorPage.route,
          currentRoute,
        ),
        _buildMenuItem(
          context,
          const Text('Login/Register'),
          LoginPage.route,
          currentRoute,
        ),
        _buildMenuItem(
          context,
          const Text('Mobile'),
          MobilePage.route,
          currentRoute,
        ),
        _buildMenuItem(
          context,
          const Text('Notifications'),
          NotificationsPage.route,
          currentRoute,
        ),
        _buildMenuItem(
          context,
          const Text('Profile'),
          ProfilePage.route,
          currentRoute,
        ),
      ],
    ),
  );
}
