import 'dart:async';

import 'package:baseflow_plugin_template/baseflow_plugin_template.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import './pages/offline_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
//import 'package:location/location.dart';

/// Defines the main theme color.
final MaterialColor themeMaterialColor =
    BaseflowPluginExample.createMaterialColor(
  const Color.fromRGBO(48, 49, 60, 1),
);

void main() {
  runApp(
    BaseflowPluginExample(
      pluginName: 'Geolocator',
      githubURL: 'https://github.com/Baseflow/flutter-geolocator',
      pubDevURL: 'https://pub.dev/packages/geolocator',
      pages: [GeolocatorWidget.createPage()],
    ),
  );
}

/// Example [Widget] showing the functionalities of the geolocator plugin
class GeolocatorWidget extends StatefulWidget {
  /// Utility method to create a page with the Baseflow templating.
  static ExamplePage createPage() {
    return ExamplePage(
      Icons.location_on,
      (context) {
        return GeolocatorWidget();
      },
    );
  }

  @override
  _GeolocatorWidgetState createState() {
    return _GeolocatorWidgetState();
  }
}

class _GeolocatorWidgetState extends State<GeolocatorWidget> {
  final List<_PositionItem> _positionItems = <_PositionItem>[];
  StreamSubscription<Position>? _positionStreamSubscription;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: ListView.builder(
        itemCount: _positionItems.length,
        itemBuilder: (context, index) {
          final positionItem = _positionItems[index];

          if (positionItem.type == _PositionItemType.permission) {
            return ListTile(
              title: Text(
                positionItem.displayValue,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          } else {
            return Card(
              child: ListTile(
                tileColor: themeMaterialColor,
                title: Text(
                  positionItem.displayValue,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            );
          }
        },
      ),
      floatingActionButton: Stack(
        children: <Widget>[
          Positioned(
            bottom: 10.0,
            right: 10.0,
            child: FloatingActionButton.extended(
              onPressed: () {
                setState(_positionItems.clear);
              },
              label: Text('clear'),
            ),
          ),
          // Positioned(
          //   bottom: 150.0,
          //   right: 10.0,
          //   child: FloatingActionButton.extended(
          //       onPressed: () async {
          //         var value = await Geolocator.getCurrentPosition(
          //             desiredAccuracy: LocationAccuracy.best);
          //         var _outvalue =
          //             // ignore: lines_longer_than_80_chars
          //             'Lat ${value.latitude}, Long ${value.longitude}, Accuracy ${value.accuracy}';

          //         _positionItems.add(
          //           _PositionItem(
          //             _PositionItemType.position,
          //             _outvalue,
          //           ),
          //         );

          //         setState(
          //           () {},
          //         );
          //       },
          //       label: Text('Current Position')),
          // ),
          Positioned(
            bottom: 220.0,
            right: 10.0,
            child: FloatingActionButton.extended(
              onPressed: _toggleListening,
              label: Text(
                () {
                  if (_positionStreamSubscription == null) {
                    return 'Start stream';
                  } else {
                    final buttonText = _positionStreamSubscription!.isPaused
                        ? 'Resume'
                        : 'Pause';

                    return '$buttonText stream';
                  }
                }(),
              ),
              backgroundColor: _determineButtonColor(),
            ),
          ),
          Positioned(
            bottom: 290.0,
            right: 10.0,
            child: FloatingActionButton.extended(
              onPressed: () async {
                await Geolocator.checkPermission().then(
                  (value) {
                    return {
                      _positionItems.add(
                        _PositionItem(
                          _PositionItemType.permission,
                          value.toString(),
                        ),
                      ),
                    };
                  },
                );
                setState(
                  () {},
                );
              },
              label: Text('Check Permission'),
            ),
          ),
          Positioned(
            bottom: 360.0,
            right: 10.0,
            child: FloatingActionButton.extended(
              onPressed: () async {
                await Geolocator.requestPermission().then(
                  (value) {
                    return {
                      _positionItems.add(
                        _PositionItem(
                          _PositionItemType.permission,
                          value.toString(),
                        ),
                      ),
                    };
                  },
                );
                setState(
                  () {},
                );
              },
              label: Text('Request Permission'),
            ),
          ),
        ],
      ),
    );
  }

  bool _isListening() {
    return !(_positionStreamSubscription == null ||
        _positionStreamSubscription!.isPaused);
  }

  Color _determineButtonColor() {
    return _isListening() ? Colors.green : Colors.red;
  }

  void _toggleListening() {
    if (_positionStreamSubscription == null) {
      final positionStream =
          Geolocator.getPositionStream(desiredAccuracy: LocationAccuracy.best);

      _positionStreamSubscription = positionStream.handleError(
        (error) {
          _positionStreamSubscription?.cancel();
          _positionStreamSubscription = null;
        },
      ).listen((position) {
        var _outvalue =
            // ignore: lines_longer_than_80_chars
            'Lat ${position.latitude}, Long ${position.longitude}, Accuracy ${position.accuracy}';

        setState(() {
          _positionItems.add(
            _PositionItem(
              _PositionItemType.position,
              _outvalue,
            ),
          );
        });
      });
      _positionStreamSubscription?.pause();
    }

    setState(() {
      if (_positionStreamSubscription == null) {
        return;
      }

      if (_positionStreamSubscription!.isPaused) {
        _positionStreamSubscription!.resume();
      } else {
        _positionStreamSubscription!.pause();
      }
    });
  }

  @override
  void dispose() {
    if (_positionStreamSubscription != null) {
      _positionStreamSubscription!.cancel();
      _positionStreamSubscription = null;
    }

    super.dispose();
  }
}

enum _PositionItemType {
  permission,
  position,
}

class _PositionItem {
  _PositionItem(this.type, this.displayValue);

  final _PositionItemType type;
  final String displayValue;
}
