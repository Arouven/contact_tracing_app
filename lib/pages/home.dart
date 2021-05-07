import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:move_to_background/move_to_background.dart';

import '../widgets/drawer.dart';

class HomePage extends StatelessWidget {
  static const String route = '/';

  @override
  Widget build(BuildContext context) {
    var markers = <Marker>[
      Marker(
        width: 80.0,
        height: 80.0,
        point: LatLng(51.5, -0.09),
        builder: (ctx) => Container(
            // child: FlutterLogo(
            //   textColor: Colors.blue,
            //   key: ObjectKey(Colors.blue),
            // ),
            ),
      ),
      Marker(
        width: 80.0,
        height: 80.0,
        point: LatLng(53.3498, -6.2603),
        builder: (ctx) => Container(
            // child: FlutterLogo(
            //   textColor: Colors.green,
            //   key: ObjectKey(Colors.green),
            // ),
            ),
      ),
      Marker(
        width: 80.0,
        height: 80.0,
        point: LatLng(48.8566, 2.3522),
        builder: (ctx) => Container(
            // child: FlutterLogo(
            //   textColor: Colors.purple,
            //   key: ObjectKey(Colors.purple),
            // ),
            ),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      drawer: buildDrawer(context, route),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [],
        ),
      ),
    );
  }

  void toggleListening() async {
    MoveToBackground.moveTaskToBack();
  }
}
