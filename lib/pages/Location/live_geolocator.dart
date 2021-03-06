import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:contact_tracing/main.dart';
import 'package:contact_tracing/pages/Location/filter.dart';
import 'package:contact_tracing/pages/Mobile/mobiles.dart';
import 'package:contact_tracing/providers/notificationbadgemanager.dart';
import 'package:contact_tracing/services/auth.dart';
import 'package:contact_tracing/services/badgeservices.dart';
import 'package:contact_tracing/services/databaseServices.dart';
import 'package:contact_tracing/services/globals.dart';
import 'package:contact_tracing/widgets/commonWidgets.dart';
import 'package:contact_tracing/widgets/drawer.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class LiveGeolocatorPage extends StatefulWidget {
  static const String route = '/live_geolocator';
  final bool downloadUpdatedLocations;
  const LiveGeolocatorPage({
    this.downloadUpdatedLocations = true,
  }); // : super(key: key);

  @override
  _LiveGeolocatorPageState createState() {
    print("in live_geolocator");
    return _LiveGeolocatorPageState();
  }
}

class _LiveGeolocatorPageState extends State<LiveGeolocatorPage> {
  Position? _currentLocation;
  MapController? _mapController = MapController();
  bool _isLoading = true;
  bool _showReload = false;
  List<Marker> _markers = [];
  Color _myMarkerColour = Colors.green;
  String _lastUpdateFromServer = '0';

  late var _subscription;
  late var _firebaseListener = null;
  bool _internetConnection = true;

  Future<void> _downloadData() async {
    String jsonBody = await DatabaseMySQLServices.downloadUpdateLocation();
    if (jsonBody != 'Error') {
      await GlobalVariables.setLocations(locations: jsonBody);
      await _useExistingData(bodyResponse: jsonBody);
    } else {
      setState(() {
        _showReload = true;
      });
    }
  }

  Future<void> _useExistingData({String bodyResponse = ''}) async {
    print("in _useExistingData()");
    String myMobileNumber = await GlobalVariables.getMobileNumber();
    if (bodyResponse == '') {
      bodyResponse = await GlobalVariables.getLocations();
    }
    final data = jsonDecode(bodyResponse);
    if (data['status'] == "200") {
      print(data);
      if (await GlobalVariables.getShowCleanUsers() == true) {
        await _populateMarkers(data["cleanUsers"], myMobileNumber,
            Colors.green[400], Colors.green.shade900);
        print('show cleanusers');
      }
      if (await GlobalVariables.getShowContactWithInfected() == true) {
        await _populateMarkers(data["contactWithInfected"], myMobileNumber,
            Colors.yellow[400], Colors.yellow.shade900);
        print('show contact with infected');
      }
      if (await GlobalVariables.getShowConfirmInfected() == true) {
        await _populateMarkers(data["confirmInfected"], myMobileNumber,
            Colors.red[400], Colors.red.shade900);
        print('show infected');
      }

      if (await GlobalVariables.getShowTestingCenters() == true) {
        await _populateCentresMarkers(data["testingcentres"], Colors.blue);
      }
      if (await GlobalVariables.getShowMyLocation() == true) {
        await _addCurrentLocationToMarkers();
      }

      try {
        int serverLastUpdated = int.parse(
            data['lastUpdateFromServer'][0]["MaxDateTime"].toString());
        _lastUpdateFromServer =
            (DateTime.fromMillisecondsSinceEpoch(serverLastUpdated * 1000))
                .toLocal()
                .toString();
        setState(() {
          _lastUpdateFromServer = _lastUpdateFromServer.substring(
              0, _lastUpdateFromServer.length - 4);
        });
      } on FormatException {
        print('problem with conversion');

        setState(() {
          _lastUpdateFromServer = 'Never';
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
    print("_generateMarkers");
    String bodyResponse = await GlobalVariables.getLocations();
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
    print(" _populateCentresMarkers(places, colour)");
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
                  DialogBox.timedDialog(
                    context: context,
                    title: 'Testing Centre',
                    body: place['name'],
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
      mobiles, myMobileNumber, colour, myMarkerColour) async {
    print('_populateMarkers(mobiles, myMobileNumber, colour, myMarkerColour)');
    if (mobiles != null) {
      //print(mobiles);
      for (var mobile in mobiles) {
        try {
          // print(mobile['mobileNumber'].toString());
          String firstInt = (mobile['mobileNumber'].toString());
          String secondInt =
              (myMobileNumber != null) ? (myMobileNumber.toString()) : '0';
          // print(myMobileNumber.toString());
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
            setState(() {
              //  if (_myMarkerColour == Colors.green) {
              _myMarkerColour = myMarkerColour;
              // }
            });
          }
        } catch (e) {
          print(e.toString());
          //print("FormatException for firstInt");

          setState(() {
            _showReload = true;
          });
        }
      }
    }
  }

  Future<void> _initLocationService() async {
    print('_initLocationService()');
    bool serviceEnabled;
    bool serviceRequestResult;
    try {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (serviceEnabled) {
        // _currentLocation ;
        Position cp = await Geolocator.getCurrentPosition(
            desiredAccuracy: geolocatorAccuracy);

        // if (mounted) {
        if (_currentLocation != null) {
          setState(() {
            print('my late');
            print(cp.toString());
            _currentLocation = cp;
          });
          // if (_mapController != null) {
          _mapController!.move(
              LatLng(_currentLocation!.latitude, _currentLocation!.longitude),
              _mapController!.zoom);
          //}
          // }
        }
      } else {
        serviceRequestResult = await Geolocator.isLocationServiceEnabled();
        if (serviceRequestResult) {
          Position cp = await Geolocator.getCurrentPosition(
              desiredAccuracy: geolocatorAccuracy);

          // if (mounted) {
          if (_currentLocation != null) {
            setState(() {
              print('my late');
              print(cp.toString());
              _currentLocation = cp;
            });
            // if (_mapController != null) {
            _mapController!.move(
                LatLng(_currentLocation!.latitude, _currentLocation!.longitude),
                _mapController!.zoom);
            //}
          }
          print('this was my loop');
          return;
        }
      }
    } on PlatformException catch (e) {
      print('meet platform exception');
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
              style: Theme.of(context).textButtonTheme.style,
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
    if (_internetConnection == false) {
      return Aesthetic.displayNoConnection();
    } else {
      if (_isLoading) {
        //loading
        return Aesthetic.displayCircle();
      } else if (_showReload) {
        return Aesthetic.refreshButton(
          context: context,
          route: LiveGeolocatorPage(),
        );
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
                        //  color: Colors.black,
                        iconSize: 30.0,
                        alignment: Alignment.centerRight,
                        onPressed: () {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => LiveGeolocatorPage(
                                downloadUpdatedLocations: true,
                              ),
                            ),
                            (e) => false,
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.info),
                        alignment: Alignment.centerRight,
                        //   color: Colors.black,
                        iconSize: 30.0,
                        onPressed: () {
                          _showLegendDialog();
                        },
                      ),
                    ],
                  ),
                ),
              ),
              new Flexible(
                child: new FlutterMap(
                  mapController:
                      (_mapController != null) ? _mapController : null,
                  options: MapOptions(
                    center:
                        LatLng(currentLatLng.latitude, currentLatLng.longitude),
                    zoom: 16.0,
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
  }

  Widget? _floatingActionButton() {
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
      LatLng currentLatLng = LatLng(
        _currentLocation!.latitude,
        _currentLocation!.longitude,
      );
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
    if (await GlobalVariables.getShowTestingCenters() == null) {
      await GlobalVariables.setShowTestingCenters(showTestingCenters: true);
    }
    if (await GlobalVariables.getShowConfirmInfected() == null) {
      await GlobalVariables.setShowConfirmInfected(showConfirmInfected: true);
    }
    if (await GlobalVariables.getShowCleanUsers() == null) {
      await GlobalVariables.setShowCleanUsers(showCleanUsers: true);
    }
    if (await GlobalVariables.getShowContactWithInfected() == null) {
      await GlobalVariables.setShowContactWithInfected(
          showContactWithInfected: true);
    }
    if (await GlobalVariables.getShowMyLocation() == null) {
      await GlobalVariables.setShowMyLocation(showMyLocation: true);
    }
  }

  Future<void> _getLocationPermission() async {
    await Geolocator.requestPermission();
    try {
      print('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');

      Position? position = await Geolocator.getLastKnownPosition();
      print('position is');
      print(position);

      if (position == null) {
        position = await Geolocator.getCurrentPosition();
        _currentLocation = position;
        //  break;
      }
      _currentLocation = position;
    } catch (e) {
      print('_getLocationPermission() ');
      print(e.toString());
    }
  }

  Future _updateWidget() async {
    int badgenumber = await GlobalVariables.getBadgeNumber();
    print(badgenumber.toString());
    Provider.of<NotificationBadgeProvider>(context, listen: false)
        .providerSetBadgeNumber(badgeNumber: (badgenumber));
  }

  @override
  void initState() {
    _updateWidget().whenComplete(() async {
      await generatePath();
    });
    if (path != "") {
      print('listening for changes from firebase');
      DatabaseReference ref = FirebaseDatabase.instance.ref(path);
// Get the Stream
      Stream<DatabaseEvent> stream = ref.onValue;

// Subscribe to the stream!
      _firebaseListener = stream.listen((DatabaseEvent event) async {
        // final mobileNumber = await GlobalVariables.getMobileNumber();
        // final fcmtoken = await FirebaseAuthenticate().getfirebasefcmtoken();
        // if (fcmtoken != null) {
        //   await DatabaseMySQLServices.updateMobilefmcToken(
        //     mobileNumber: mobileNumber,
        //     fcmtoken: fcmtoken,
        //   );
        // }
        try {
          //DataSnapshot snapshot = event.snapshot; // DataSnapshot
          print('change detected updating badges');
          await BadgeServices.updateBadge();
          int badgenumber = await GlobalVariables.getBadgeNumber();
          print(badgenumber.toString());
          Provider.of<NotificationBadgeProvider>(context, listen: false)
              .providerSetBadgeNumber(badgeNumber: (badgenumber));
        } catch (e) {
          print(e.toString());
          print('firebase exception');
        }
      });
    }

    _subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      print('connectivity result');
      print(result);
      if (result == ConnectivityResult.none) {
        setState(() {
          _internetConnection = false;
        });
      } else {
        setState(() {
          _internetConnection = true;
          _mapController = null;
        });
      }
    });

    try {
      _getLocationPermission().whenComplete(() {
        if (_mapController == null) {
          _mapController = MapController();
        }
        checkMobileNumber(context: context).whenComplete(() {
          _setFilters();
          _initLocationService().whenComplete(() {
            setState(() {});
          });
          _generateMarkers().whenComplete(() {
            setState(() {});
          });
        });
      });
    } catch (e) {
      print(e);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    LatLng currentLatLng;
    // var locationAccuracy;
    // Until currentLocation is initially updated, Widget can locate to 0, 0
    // by default or store previous location value to show.
    if (_currentLocation != null) {
      currentLatLng = LatLng(
        _currentLocation!.latitude,
        _currentLocation!.longitude,
      );
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
            // backgroundColor: Colors.blue,
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
    _subscription.cancel();
    // if (_firebaseListener != null) {
    //   _firebaseListener.cancel();
    // }
    super.dispose();
  }

  @override
  void deactivate() {
    _subscription.cancel();
    // if (_firebaseListener != null) {
    //   _firebaseListener.cancel();
    // }
    super.deactivate();
  }
}
