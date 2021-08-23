// import 'package:contact_tracing/classes/globals.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong/latlong.dart';
// import 'package:geolocator/geolocator.dart';
import '../widgets/drawer.dart';

class MobilePage extends StatefulWidget {
  static const String route = '/mobiles';

  @override
  _MobilePageState createState() {
    return _MobilePageState();
  }
}

class _MobilePageState extends State<MobilePage> {
  final countries = [
    'Pakistan',
    'France',
    'Spain',
    'KSA',
    'Brasil',
    'Australia',
    'UAE',
    'USA',
    'UK',
    'India',
    'Afghanistan',
    'Bangladsh',
    'Egypt',
    'Pakistan',
    'France',
    'Spain',
    'KSA',
    'Brasil',
    'Australia',
    'UAE',
    'USA',
    'UK',
    'India',
    'Afghanistan',
    'Bangladsh',
    'Egypt'
  ];
  void addItem() {
    setState(() {
      countries.add(countries[0]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        top: true,
        bottom: true,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Mobile'),
            centerTitle: true,
            backgroundColor: Colors.blue,
          ),
          drawer: buildDrawer(context, MobilePage.route),
          body: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.separated(
                    itemCount: countries.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(countries[index]),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Divider();
                    },
                  ),
                ),
                FloatingActionButton(
                  child: Icon(Icons.add),
                  onPressed: addItem,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
