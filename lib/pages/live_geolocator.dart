import 'dart:convert';
//import 'dart:html';
import 'dart:ui';

import 'package:contact_tracing/classes/globals.dart';
import 'package:contact_tracing/pages/splash.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:speech_bubble/speech_bubble.dart';

import 'package:flutter_map/flutter_map.dart';
//import 'package:map_markers/map_markers.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/drawer.dart';
import 'package:http/http.dart' as http;

//import 'package:flutter/material.dart';
import 'package:cool_alert/cool_alert.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:animated_dialog_box/animated_dialog_box.dart';

//
class LiveGeolocatorPage extends StatefulWidget {
  static const String route = '/live_geolocator';

  @override
  _LiveGeolocatorPageState createState() {
    return _LiveGeolocatorPageState();
  }
}

class _LiveGeolocatorPageState extends State<LiveGeolocatorPage> {
  Position _currentLocation;
  MapController _mapController;
  bool _isLoading = true;
  String _serviceError = '';
  List<Marker> _markers = [];
  Color _myMarkerColour = Colors.green;
  String _lastUpdateFromServer = '0';

  @override
  void initState() {
    super.initState();
    _mapController = MapController();

    initLocationService().whenComplete(() {
      setState(() {});
    });
  }

  Future<String> generateMarkers() async {
    final res = await http.get(Uri.parse(latestUpdateLocationsUrl));
    // print(latestUpdateLocationsUrl);
    final data = jsonDecode(res.body);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String myMobileId = prefs.getString("mobileId");

    if (data['status'] == "200") {
      print(data);
      await populateMarkers(data["confirmInfected"], myMobileId,
          Colors.red[400], Colors.red.shade900);
      await populateMarkers(data["contactWithInfected"], myMobileId,
          Colors.yellow[400], Colors.yellow.shade900);
      await populateMarkers(data["cleanUsers"], myMobileId, Colors.green[400],
          Colors.green.shade900);
      await populateCentresMarkers(data["testingcentres"], Colors.blue);
      try {
        int serverLastUpdated = int.parse(
            data['lastUpdateFromServer'][0]["MaxDateTime"].toString());
        _lastUpdateFromServer =
            (DateTime.fromMillisecondsSinceEpoch(serverLastUpdated * 1000))
                .toLocal()
                .toString();
        _lastUpdateFromServer = _lastUpdateFromServer.substring(
            0, _lastUpdateFromServer.length - 4);
      } catch (exception) {
        print('problem');
      }
      print("markers populated");
    } else {
      print('status not 200');
      print(data);
    }

    return 'finish initialising';
  }

  Future<void> populateCentresMarkers(places, colour) async {
    if (places != null) {
      // print(places);
      for (var place in places) {
        //print(place['name']);
        Marker marker = new Marker(
          width: 25,
          height: 25,
          point: LatLng(double.parse(place['latitude'].toString()),
              double.parse(place['longitude'].toString())),
          builder: (context) {
            return new Container(
              child: new IconButton(
                icon: new Icon(Icons.location_on_outlined),
                color: colour,
                iconSize: 25.0,
                onPressed: () {
                  CoolAlert.show(
                    context: context,
                    type: CoolAlertType.info,
                    title: 'Testing Centre',
                    text: place['name'],
                    autoCloseDuration: Duration(seconds: 5),
                  );
                  //  print(place['name']);
                },
              ),
            );
          },
        );
        _markers.add(marker);
      }
    }
  }

  Future<void> populateMarkers(
      mobiles, myMobileId, colour, myMarkerColour) async {
    if (mobiles != null) {
      //print(mobiles);
      for (var mobile in mobiles) {
        try {
          int firstInt = int.parse(mobile['mobileId'].toString());
          int secondInt = int.parse(myMobileId.toString());
          if (firstInt != secondInt) {
            //print(firstInt.toString() + '  ' + secondInt.toString());
            Marker marker = new Marker(
              width: 25,
              height: 25,
              point: LatLng(double.parse(mobile['latitude'].toString()),
                  double.parse(mobile['longitude'].toString())),
              builder: (context) {
                return new Container(
                  child: new IconButton(
                    icon: new Icon(Icons.location_on),
                    color: colour,
                    iconSize: 25.0,
                    onPressed: () {
                      print(mobile['MaxDateTime']);
                    },
                  ),
                );
              },
            );
            _markers.add(marker);
          } else {
            _myMarkerColour = myMarkerColour;
          }
        } on FormatException {
          print("FormatException for firstInt");
        }
      }
    }
  }

  Future<void> initLocationService() async {
    bool serviceEnabled;
    bool serviceRequestResult;
    try {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (serviceEnabled) {
        _currentLocation = await Geolocator.getCurrentPosition(
            desiredAccuracy: geolocatorAccuracy);

        _mapController.move(
            LatLng(_currentLocation.latitude, _currentLocation.longitude),
            _mapController.zoom);
      } else {
        serviceRequestResult = await Geolocator.isLocationServiceEnabled();
        if (serviceRequestResult) {
          await initLocationService();
          return;
        }
      }
    } on PlatformException catch (e) {
      print(e);
      if (e.code == 'PERMISSION_DENIED') {
        _serviceError = e.message;
      } else if (e.code == 'SERVICE_STATUS_ERROR') {
        _serviceError = e.message;
      }
    }
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Colors Info'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                new Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Colors.green[400],
                    ),
                    Expanded(
                      child: Text("Mobiles that are safe."),
                    ),
                  ],
                ),
                new Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Colors.green.shade900,
                    ),
                    Expanded(
                      child: Text("Your Mobile is safe."),
                    ),
                  ],
                ),
                new Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Colors.yellow[400],
                    ),
                    Expanded(
                      child: Text("Mobiles that has been contact."),
                    ),
                  ],
                ),
                new Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Colors.yellow.shade900,
                    ),
                    Expanded(
                      child: Text("Your Mobile is a contact."),
                    ),
                  ],
                ),
                new Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Colors.red[400],
                    ),
                    Expanded(
                      child: Text("Mobiles that are infected."),
                    ),
                  ],
                ),
                new Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Colors.red.shade900,
                    ),
                    Expanded(
                      child: Text("Your Mobile is infected."),
                    ),
                  ],
                ),
                new Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      color: Colors.blue,
                    ),
                    Expanded(
                      child: Text("All Testing Centers."),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  builder(currentLatLng) {
    return FutureBuilder<String>(
      future: generateMarkers(),
      builder: (context, snapshot) {
        _isLoading = true;
        if (snapshot.hasData) {
          print(_markers.toString());
          _isLoading = false;
          return Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: new Container(
                    child: new Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                              'Updated: ${_lastUpdateFromServer.toString()}',
                              textAlign: TextAlign.left),
                        ),
                        IconButton(
                          icon: Icon(Icons.refresh),
                          color: Colors.black,
                          iconSize: 30.0,
                          alignment: Alignment.centerRight,
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => SplashPage()));
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.info),
                          alignment: Alignment.centerRight,
                          color: Colors.black,
                          iconSize: 30.0,
                          onPressed: () {
                            _showMyDialog();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Flexible(
                  child: FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      center: LatLng(
                          currentLatLng.latitude, currentLatLng.longitude),
                      zoom: 10.0,
                      interactiveFlags: InteractiveFlag.all,
                    ),
                    layers: [
                      TileLayerOptions(
                        urlTemplate:
                            'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                        subdomains: ['a', 'b', 'c'],
                        tileProvider: NonCachingNetworkTileProvider(),
                      ),
                      MarkerLayerOptions(markers: _markers),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Container(
            child: Column(
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 60,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text('Error: ${snapshot.error}'),
                )
              ],
            ),
          );
        } else {
          return Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 1.3,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                // Padding(
                //   //padding: EdgeInsets.only(top: 16),
                //   child:
                Text('Awaiting result...'),
                // )
              ],
            ),
          );
        }
      },
    );
  }

  addCurrentLocationToMarkers(currentLatLng) {
    var marker = new Marker(
      width: 30,
      height: 30,
      point: currentLatLng,
      builder: (context) {
        return Container(
          child: IconButton(
            icon: Icon(Icons.location_on),
            color: _myMarkerColour,
            iconSize: 30.0,
            onPressed: () {},
          ),
        );
      },
    );
    _markers.add(marker);
  }

  @override
  Widget build(BuildContext context) {
    LatLng currentLatLng;
    var locationAccuracy;
    // Until currentLocation is initially updated, Widget can locate to 0, 0
    // by default or store previous location value to show.
    if (_currentLocation != null) {
      currentLatLng =
          LatLng(_currentLocation.latitude, _currentLocation.longitude);
      locationAccuracy = _currentLocation.accuracy;
    } else {
      currentLatLng = LatLng(0, 0);
      locationAccuracy = 0;
    }
    addCurrentLocationToMarkers(currentLatLng);
    return Container(
      color: Colors.white,
      child: SafeArea(
        top: true,
        bottom: true,
        child: Scaffold(
          appBar: AppBar(
            title: Text('GPS Live Location'),
            centerTitle: true,
            backgroundColor: Colors.blue,
          ),
          drawer: buildDrawer(context, LiveGeolocatorPage.route),
          body: builder(currentLatLng),
          floatingActionButton: _isLoading
              ? null
              : FloatingActionButton(
                  child: Icon(Icons.search),
                  onPressed: () {
                    //MoveToBackground.moveTaskToBack();
                  },
                ),
        ),
      ),
    );
  }
}
