import 'dart:convert';

import 'package:contact_tracing/classes/globals.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
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

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    generateMarkers();
    initLocationService();
  }

  void initLocationService() async {
    bool serviceEnabled;
    bool serviceRequestResult;
    Position location;
    try {
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

  void generateMarkers() async {
    final res = await http.get(Uri.parse(latestUpdateLocationsUrl));
    final data = jsonDecode(res.body);

    if (data['status'] == "200") {
      print("00000000000000000000000000000000000000000000000000000000000000");
      print(data);
      // msgError = "User does not exist or wrong password!";
      // _username.clear();
      // _password.clear();
      setState(
        () {
          //register btn appear
        },
      );
    } else {
      print(data);
      // msgError = ""; //"User logged in";
      // _username.clear();
      // _password.clear();
      setState(
        () {
          //redirect to home
        },
      );
    }
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
                      zoom: 15.0,
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
                            width: 35,
                            height: 35,
                            point: currentLatLng,
                            builder: (ctx) {
                              return Container(
                                child: IconButton(
                                  icon: Icon(Icons.location_on),
                                  color: Colors.red,
                                  iconSize: 35.0,
                                  onPressed: () {},
                                ),
                              );
                            },
                          ),
                        ],
                      )
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
