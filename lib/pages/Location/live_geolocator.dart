import 'dart:convert';
import 'dart:ui';

import 'package:contact_tracing/classes/globals.dart';
import 'package:contact_tracing/pages/splash.dart';
import 'package:contact_tracing/pages/Location/filter.dart';
import 'package:contact_tracing/widgets/commonWidgets.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/drawer.dart';
import 'package:http/http.dart' as http;
// import 'package:grouped_buttons/grouped_buttons.dart';

//import 'package:flutter/material.dart';
import 'package:cool_alert/cool_alert.dart';

class LiveGeolocatorPage extends StatefulWidget {
  static const String route = '/live_geolocator';
  final bool downloadUpdatedLocations;
  const LiveGeolocatorPage({
    this.downloadUpdatedLocations = true,
  }); // : super(key: key);

  @override
  _LiveGeolocatorPageState createState() {
    return _LiveGeolocatorPageState();
  }
}

class _LiveGeolocatorPageState extends State<LiveGeolocatorPage> {
  Position _currentLocation;
  MapController _mapController;
  bool _isLoading = true;
  bool _showReload = false;
  List<Marker> _markers = [];
  Color _myMarkerColour = Colors.green;
  String _lastUpdateFromServer = '0';

  Future<void> _downloadData() async {
    try {
      final res = await http.get(Uri.parse(latestUpdateLocationsUrl));
      // print(latestUpdateLocationsUrl);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String jsonBody = res.body;
      await prefs.setString('Locations', jsonBody);
      _useExistingData(bodyResponse: jsonBody);
    } catch (e) {
      print('json request problem');
      print(e);
      setState(() {
        _showReload = true;
      });
    }
  }

  Future<void> _useExistingData({String bodyResponse = ''}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String myMobileId = prefs.getString("mobileId");
    if (bodyResponse == '') {
      bodyResponse = prefs.getString('Locations');
    }
    final data = jsonDecode(bodyResponse);
    if (data['status'] == "200") {
      print(data);
      if (prefs.getBool('showConfirmInfected')) {
        await _populateMarkers(data["confirmInfected"], myMobileId,
            Colors.red[400], Colors.red.shade900);
      }
      if (prefs.getBool('showContactWithInfected')) {
        await _populateMarkers(data["contactWithInfected"], myMobileId,
            Colors.yellow[400], Colors.yellow.shade900);
      }
      if (prefs.getBool('showCleanUsers')) {
        await _populateMarkers(data["cleanUsers"], myMobileId,
            Colors.green[400], Colors.green.shade900);
      }
      if (prefs.getBool('showTestingCenters')) {
        await _populateCentresMarkers(data["testingcentres"], Colors.blue);
      }
      if (prefs.getBool('showMyLocation')) {
        await _addCurrentLocationToMarkers();
      }

      try {
        int serverLastUpdated = int.parse(
            data['lastUpdateFromServer'][0]["MaxDateTime"].toString());
        _lastUpdateFromServer =
            (DateTime.fromMillisecondsSinceEpoch(serverLastUpdated * 1000))
                .toLocal()
                .toString();
        _lastUpdateFromServer = _lastUpdateFromServer.substring(
            0, _lastUpdateFromServer.length - 4);
      } on FormatException {
        print('problem with conversion');

        setState(() {
          _showReload = true;
        });
      }
      print("markers populated");
    } else {
      print('status not 200 need to redownload');
      print(data);
      setState(() {
        _showReload = true;
      });
    }
  }

  Future<void> _generateMarkers() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String bodyResponse = prefs.getString('Locations');
    if (widget.downloadUpdatedLocations ||
        bodyResponse == null ||
        bodyResponse == '') {
      await _downloadData();
    } else {
      await _useExistingData();
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _populateCentresMarkers(places, colour) async {
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

  Future<void> _populateMarkers(
      mobiles, myMobileId, colour, myMarkerColour) async {
    if (mobiles != null) {
      //print(mobiles);
      for (var mobile in mobiles) {
        try {
          int firstInt = int.parse(mobile['mobileId'].toString());
          int secondInt = int.parse(myMobileId.toString());
          if (firstInt != secondInt) {
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

          setState(() {
            _showReload = true;
          });
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
        // _currentLocation ;
        Position cp = await Geolocator.getCurrentPosition(
            desiredAccuracy: geolocatorAccuracy);
        // setState(() {
        //   _currentLocation = cp;
        // });
        // if (mounted) {
        setState(() {
          _currentLocation = cp;
        });
        _mapController.move(
            LatLng(_currentLocation.latitude, _currentLocation.longitude),
            _mapController.zoom);
        //}
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
        print(e.message);
      } else if (e.code == 'SERVICE_STATUS_ERROR') {
        print(e.message);
      }
    }
  }

  Future<void> _showLegendDialog() async {
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

  Widget _body(currentLatLng) {
    print(_showReload);
    if (_isLoading) {
      //loading
      return Aesthetic.displayCircle();
    } else if (_showReload) {
      return Aesthetic.refreshButton(
          context: context, route: LiveGeolocatorPage());
    } else {
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
                        _showLegendDialog();
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
                  center:
                      LatLng(currentLatLng.latitude, currentLatLng.longitude),
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
    }
  }

  Widget _floatingActionButton() {
    if (_isLoading || _showReload) {
      return null;
    } else {
      return FloatingActionButton(
        child: Icon(Icons.filter_list_alt),
        onPressed: () {
          _markers.clear();
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => FilterPage()));
        },
      );
    }
  }

  Future<void> _addCurrentLocationToMarkers() async {
    print(_currentLocation);
    if (_currentLocation != null) {
      LatLng currentLatLng =
          LatLng(_currentLocation.latitude, _currentLocation.longitude);
      Marker marker = new Marker(
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
      // setState(() {
      _markers.add(marker);
      // if (!mounted) {
      //   setState(() {});
      // }
      // });
      print('addmylocationfunction');
    } else {
      print('else part');
      _currentLocation = await Geolocator.getCurrentPosition(
          desiredAccuracy: geolocatorAccuracy);

      await _addCurrentLocationToMarkers();
    }
  }

  Future<void> _setFilters() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('showTestingCenters') == null) {
      await prefs.setBool('showTestingCenters', true);
    }
    if (prefs.getBool('showConfirmInfected') == null) {
      await prefs.setBool('showConfirmInfected', true);
    }
    if (prefs.getBool('showCleanUsers') == null) {
      await prefs.setBool('showCleanUsers', true);
    }
    if (prefs.getBool('showContactWithInfected') == null) {
      await prefs.setBool('showContactWithInfected', true);
    }
    if (prefs.getBool('showMyLocation') == null) {
      await prefs.setBool('showMyLocation', true);
    }
  }

  @override
  void initState() {
    super.initState();

    _mapController = MapController();
    _setFilters();
    initLocationService().whenComplete(() {
      setState(() {});
    });
    _generateMarkers().whenComplete(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    LatLng currentLatLng;
    // var locationAccuracy;
    // Until currentLocation is initially updated, Widget can locate to 0, 0
    // by default or store previous location value to show.
    if (_currentLocation != null) {
      currentLatLng =
          LatLng(_currentLocation.latitude, _currentLocation.longitude);
      //locationAccuracy = _currentLocation.accuracy;
    } else {
      currentLatLng = LatLng(0, 0);
      //locationAccuracy = 0;
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
          body: _body(currentLatLng),
          floatingActionButton: _floatingActionButton(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _markers.clear();
    super.dispose();
  }
}
