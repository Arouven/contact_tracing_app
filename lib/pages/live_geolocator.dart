import 'package:contact_tracing/classes/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../classes/write.dart';
import '../permissions/permissions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../widgets/drawer.dart';

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
  Writefile _wf;

  @override
  void initState() {
    super.initState();
    initialiser();

    _mapController = MapController();
    initLocationService();
  }

  void initialiser() async {
    Scheduler scheduler = new Scheduler();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("nationalIdNumber", "P61548465161654816");
    await prefs.setString("mobileID", "100");
    _wf = new Writefile(
        '${prefs.getString("mobileID")}_${prefs.getString("nationalIdNumber")}_geolocatorbest.csv');
    var ffp = prefs.getString("fullFilePath");
    scheduler.cronFileUpload(ffp);
  }

  void initLocationService() async {
    bool serviceEnabled;
    bool serviceRequestResult;
    Position location;
    try {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (serviceEnabled) {
        await Geolocator.requestPermission();
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
          _toggleListening(LocationAccuracy.best, Duration(minutes: 1));
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
    );
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
            _wf.writeToFile(
                '${position.latitude.toString()}',
                '${position.longitude.toString()}',
                '${position.accuracy.toString()}');

            _mapController.move(
                LatLng(_currentLocation.latitude, _currentLocation.longitude),
                _mapController.zoom);
          },
        );
      },
    );
  }
}
