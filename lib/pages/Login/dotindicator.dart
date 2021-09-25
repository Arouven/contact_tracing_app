import 'dart:math';

import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';

class RegisterDots extends StatefulWidget {
  static const String route = '/registerDots';
  @override
  _RegisterDotsState createState() => _RegisterDotsState();
}

enum pages { r1, register }

class _RegisterDotsState extends State<RegisterDots> {
  final _totalDots = 5;
  double _currentPosition = 0.0;
  pages _page = pages.r1;
  void _formChange() async {
    setState(() {
      if (_page == pages.register) {
        _page = pages.r1;
      } else {
        _page = pages.register;
      }
    });
  }

// if (_form == FormType.login) {
  double _validPosition(double position) {
    if (position >= _totalDots) return 0;
    if (position < 0) return _totalDots - 1.0;
    return position;
  }

  void _updatePosition(double position) {
    setState(() => _currentPosition = _validPosition(position));
  }

  Widget _buildRow(List<Widget> widgets) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: widgets,
      ),
    );
  }

  String getCurrentPositionPretty() {
    return (_currentPosition + 1.0).toStringAsPrecision(2);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Dots indicator example'),
        ),
        body: Stack(
          children: [
            ListView(
              children: [
                _buildRow([
                  FloatingActionButton(
                    child: const Icon(Icons.remove),
                    onPressed: () {
                      _currentPosition = _currentPosition.ceilToDouble();
                      _updatePosition(max(--_currentPosition, 0));
                    },
                  ),
                  FloatingActionButton(
                    child: const Icon(Icons.add),
                    onPressed: () {
                      _currentPosition = _currentPosition.floorToDouble();
                      _updatePosition(min(
                        ++_currentPosition,
                        _totalDots.toDouble(),
                      ));
                    },
                  )
                ]),
                _buildRow([
                  Text(
                    'Vertical',
                    style:
                        TextStyle(fontWeight: FontWeight.w700, fontSize: 18.0),
                  ),
                  Text(
                    'Vertical reversed',
                    style:
                        TextStyle(fontWeight: FontWeight.w700, fontSize: 18.0),
                  ),
                ]),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: new DotsIndicator(
                dotsCount: _totalDots,
                position: _currentPosition,
                decorator: DotsDecorator(
                  size: const Size.square(9.0),
                  activeSize: const Size(18.0, 9.0),
                  activeShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
