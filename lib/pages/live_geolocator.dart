import 'dart:convert';

import 'package:contact_tracing/classes/globals.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/drawer.dart';
import 'package:http/http.dart' as http;

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
  bool _permission = false;
  String _serviceError = '';
  List<Marker> _markers = [];
  Color _myMarkerColour = Colors.green;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();

    initLocationService();
  }

  Future generateMarkers() async {
    final res = await http.get(Uri.parse(latestUpdateLocationsUrl));
    print(latestUpdateLocationsUrl);
    final data = jsonDecode(res.body);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String myMobileId = prefs.getString("mobileId");

    if (data['status'] == "200") {
      print(data);

      populateMarkers(data["confirmInfected"], myMobileId, Colors.red[400],
          Colors.red.shade900);
      populateMarkers(data["contactWithInfected"], myMobileId,
          Colors.yellow[400], Colors.yellow.shade900);
      populateCentresMarkers(data["testingcentres"], Colors.blue);
      print("00000000000000000000000000000000000000000000000000000000000000");
    } else {
      print(data);
    }
    //print(_markers);
    //return _markers;
  }

  void populateCentresMarkers(places, colour) {
    if (places != null) {
      print(places);
      for (var place in places) {
        print(place['longitude']);
        print(place['latitude']);
        print(place['name']);
        var marker = Marker(
          width: 25,
          height: 25,
          point: LatLng(double.parse(place['latitude'].toString()),
              double.parse(place['longitude'].toString())),
          builder: (ctx) {
            return Container(
              child: IconButton(
                icon: Icon(Icons.location_on_outlined),
                color: colour,
                iconSize: 25.0,
                onPressed: () {
                  print(place['name']);
                },
              ),
            );
          },
        );
        _markers.add(marker);
      }
    }
  }

  void populateMarkers(mobiles, myMobileId, colour, myMarkerColour) {
    if (mobiles != null) {
      print(mobiles);
      for (var mobile in mobiles) {
        try {
          int firstInt = int.parse(mobile['mobileId'].toString());
          int secondInt = int.parse(myMobileId.toString());
          if (firstInt != secondInt) {
            print(mobile['mobileId']);
            print(mobile['longitude']);
            print(mobile['latitude']);
            print(mobile['MaxDateTime']);
            var marker = Marker(
              width: 25,
              height: 25,
              point: LatLng(double.parse(mobile['latitude'].toString()),
                  double.parse(mobile['longitude'].toString())),
              builder: (ctx) {
                return Container(
                  child: IconButton(
                    icon: Icon(Icons.location_on),
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

  void initLocationService() async {
    bool serviceEnabled;
    bool serviceRequestResult;
    Position location;
    try {
      await generateMarkers();
      serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (serviceEnabled) {
        await Geolocator.checkPermission().then(
          (value) {
            return {
              if (value.toString() == 'LocationPermission.always')
                {_permission = true},
            };
          },
        );

        if (_permission) {
          location = await Geolocator.getCurrentPosition();
          _currentLocation = location;
          _toggleListening(geolocatorAccuracy, Duration(minutes: 1));
        }
      } else {
        serviceRequestResult = await Geolocator.isLocationServiceEnabled();
        if (serviceRequestResult) {
          initLocationService();
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
      location = null;
    }
  }

  void _toggleListening(
      LocationAccuracy desiredAccuracy, Duration intervalDuration) {
    final positionStream = Geolocator.getPositionStream(
      desiredAccuracy: desiredAccuracy,
      intervalDuration: intervalDuration,
    );
    positionStream.listen(
      (position) {
        setState(
          () {
            _currentLocation = position;

            _mapController.move(
                LatLng(_currentLocation.latitude, _currentLocation.longitude),
                _mapController.zoom);
          },
        );
      },
    );
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
          body: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: _serviceError.isEmpty
                      ? Text(
                          'latitude ${currentLatLng.latitude}, longitude ${currentLatLng.longitude}, accuracy ${locationAccuracy.toString()}')
                      : Text(
                          'Error occured while acquiring location. Error Message : '
                          '$_serviceError'),
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
                      MarkerLayerOptions(
                        markers: <Marker>[
                          Marker(
                            width: 25,
                            height: 25,
                            point: currentLatLng,
                            builder: (ctx) {
                              return Container(
                                child: IconButton(
                                  icon: Icon(Icons.location_on),
                                  color: _myMarkerColour,
                                  iconSize: 25.0,
                                  onPressed: () {},
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      MarkerLayerOptions(
                        markers: _markers,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
