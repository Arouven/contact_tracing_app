import 'package:contact_tracing/pages/login.dart';
import 'package:contact_tracing/pages/mobiles.dart';
import 'package:contact_tracing/pages/register.dart';
import 'package:flutter/material.dart';
import '../pages/live_geolocator.dart';
import '../pages/register.dart';
import '../pages/login.dart';
import '../pages/home.dart';

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
          HomePage.route,
          currentRoute,
        ),
        _buildMenuItem(
          context,
          const Text('GPS Live'),
          LiveGeolocatorPage.route,
          currentRoute,
        ),
        _buildMenuItem(
          context,
          const Text('Register'),
          RegisterPage.route,
          currentRoute,
        ),
        _buildMenuItem(
          context,
          const Text('Login'),
          LoginPage.route,
          currentRoute,
        ),
        _buildMenuItem(
          context,
          const Text('Mobile'),
          MobilePage.route,
          currentRoute,
        ),
      ],
    ),
  );
}
