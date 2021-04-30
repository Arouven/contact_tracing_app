import 'package:contact_tracing_app/pages/permissions.dart';
import 'package:contact_tracing_app/pages/write.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:geolocator/geolocator.dart';

import '../widgets/drawer.dart';

class LiveGeolocatorPage extends StatefulWidget {
  static const String route = '/live_geolocator';

  @override
  _LiveGeolocatorPageState createState() => _LiveGeolocatorPageState();
}

class _LiveGeolocatorPageState extends State<LiveGeolocatorPage> {
  Position _currentLocation;
  MapController _mapController;
  bool _permission = false;
  final bool _liveUpdate = true;
  String _serviceError = '';
  var interActiveFlags = InteractiveFlag.all;
  var wf = new writefile();
  LocationAccuracy acc;
  String typeAccuracy;
  // final
  //
  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    var permission = new permissions();
    permission.requestAllPermissions();

    initLocationService();
  }

  void initLocationService() async {
    acc = LocationAccuracy.high;
    typeAccuracy = 'high';

    bool serviceEnabled;
    bool serviceRequestResult;
    Position location;
    try {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (serviceEnabled) {
        var permission = await Geolocator.requestPermission();
        // ignore: unrelated_type_equality_checks
        _permission = permission == Geolocator.checkPermission();

        if (_permission) {
          location = await Geolocator.getCurrentPosition();
          _currentLocation = location;

          Geolocator.getPositionStream(
            desiredAccuracy: acc,
            intervalDuration: Duration(milliseconds: 1000),
          ).listen(
            (Position position) async {
              if (mounted) {
                setState(
                  () {
                    _currentLocation = position;

                    // If Live Update is enabled, move map center
                    if (_liveUpdate) {
                      _mapController.move(
                          LatLng(_currentLocation.latitude,
                              _currentLocation.longitude),
                          _mapController.zoom);
                    }
                  },
                );
              }
            },
          );
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

  @override
  Widget build(BuildContext context) {
    LatLng currentLatLng;
    // ignore: prefer_typing_uninitialized_variables
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

    wf.fileName = 'g.$typeAccuracy.txt';
    wf.writeToFile(
        "${DateTime.now().toString()},${currentLatLng.latitude.toString()},${currentLatLng.longitude.toString()},${locationAccuracy.toString()},$typeAccuracy");

    var markers = <Marker>[
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
              onPressed: () {
                print('hello');
              },
            ),
          );
        },
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text('GPS Live Location'),
        centerTitle: true,
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
                  center:
                      LatLng(currentLatLng.latitude, currentLatLng.longitude),
                  zoom: 15.0,
                  interactiveFlags: interActiveFlags,
                ),
                layers: [
                  TileLayerOptions(
                    urlTemplate:
                        'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    subdomains: ['a', 'b', 'c'],
                    // For example purposes. It is recommended to use
                    // TileProvider with a caching and retry strategy, like
                    // NetworkTileProvider or CachedNetworkTileProvider
                    tileProvider: NonCachingNetworkTileProvider(),
                  ),
                  MarkerLayerOptions(markers: markers)
                ],
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: Stack(
        children: <Widget>[
          Positioned(
            bottom: 10.0,
            right: 10.0,
            child: FloatingActionButton.extended(
              onPressed: () {
                setState(
                  () {
                    acc = LocationAccuracy.bestForNavigation;
                    typeAccuracy = 'bestForNavigation';
                  },
                );
              },
              label: Text('$typeAccuracy'),
            ),
          ),
          Positioned(
            bottom: 80.0,
            right: 10.0,
            child: FloatingActionButton.extended(
              onPressed: () {
                setState(
                  () {
                    acc = LocationAccuracy.best;
                    typeAccuracy = 'best';
                  },
                );
              },
              label: Text('$typeAccuracy'),
            ),
          ),
          Positioned(
            bottom: 150.0,
            right: 10.0,
            child: FloatingActionButton.extended(
              onPressed: () {
                setState(
                  () {
                    acc = LocationAccuracy.high;
                    typeAccuracy = 'high';
                  },
                );
              },
              label: Text('$typeAccuracy'),
            ),
          ),
          Positioned(
            bottom: 220.0,
            right: 10.0,
            child: FloatingActionButton.extended(
              onPressed: () {
                setState(
                  () {
                    acc = LocationAccuracy.medium;
                    typeAccuracy = 'medium';
                  },
                );
              },
              label: Text('$typeAccuracy'),
            ),
          ),
          Positioned(
            bottom: 290.0,
            right: 10.0,
            child: FloatingActionButton.extended(
              onPressed: () {
                setState(
                  () {
                    acc = LocationAccuracy.low;
                    typeAccuracy = 'low';
                  },
                );
              },
              label: Text('$typeAccuracy'),
            ),
          ),
          Positioned(
            bottom: 360.0,
            right: 10.0,
            child: FloatingActionButton.extended(
              onPressed: () {
                setState(
                  () {
                    acc = LocationAccuracy.lowest;
                    typeAccuracy = 'lowest';
                  },
                );
              },
              label: Text('$typeAccuracy'),
            ),
          ),
        ],
      ),

      //   floatingActionButton: Builder(builder: (BuildContext context) {
      //     return FloatingActionButton(
      //       onPressed: () {
      //         setState(
      //           () {
      //             _liveUpdate = !_liveUpdate;

      //             if (_liveUpdate) {
      //               interActiveFlags = InteractiveFlag.rotate |
      //                   InteractiveFlag.pinchZoom |
      //                   InteractiveFlag.doubleTapZoom;

      //               ScaffoldMessenger.of(context).showSnackBar(
      //                 SnackBar(
      //                   content: Text(
      //                       'In live update mode only zoom and rotation are enable'),
      //                 ),
      //               );
      //             } else {
      //               interActiveFlags = InteractiveFlag.all;
      //             }
      //           },
      //         );
      //       },
      //     );
      //   }),
      //
    );
  }
}
