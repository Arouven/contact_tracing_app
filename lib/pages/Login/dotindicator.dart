import 'dart:math';

import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';

class RegisterDotsPage extends StatefulWidget {
  static const String route = '/registerDots';
  @override
  _RegisterDotsState createState() => _RegisterDotsState();
}

enum pages {
  r1, //firstname, lastname, email
  r2, //country
  r3, //dob
  r4, //nic, address
  r5, //useername, password
}

class _RegisterDotsState extends State<RegisterDotsPage> {
  final _totalDots = pages.values.length;
  double _currentPosition = 0.0;

  var _firstName = '';
  var _lastName = '';
  var _email = '';
  var _country = '';
  var _dateOfBirth = '';
  var _nationalIdNumber = '';
  var _address = '';
  var _username = '';
  var _password = '';

  pages _page = pages.r1;
  void _formChange() async {
    setState(() {
      if (_page == pages.r2) {
        _page = pages.r1;
      } else {
        _page = pages.r2;
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
  void initState() {
    print(_totalDots);

    print(_firstName);
    print(_lastName);
    print(_email);
    print(_country);
    print(_dateOfBirth);
    print(_nationalIdNumber);
    print(_address);
    print(_username);
    print(_password);
    super.initState();
  }

  _bottom() {
    List<Widget> bottomWidgets = [];
    // if (_currentPosition == 0.0) {
    // } else if (_currentPosition == 5.0) {
    // } else {
    //   bottomWidgets.add(
    //     Align(
    //       alignment: Alignment.bottomCenter,
    //       child: ListView(
    //         children: [
    //           _buildRow([
    //             FloatingActionButton(
    //               child: const Icon(Icons.remove),
    //               onPressed: () {
    //                 print('before ' + (_currentPosition.toString()));
    //                 _currentPosition = _currentPosition.ceilToDouble();
    //                 _updatePosition(max(--_currentPosition, 0));
    //                 print('after ' + (_currentPosition.toString()));
    //               },
    //             ),
    //             FloatingActionButton(
    //               child: const Icon(Icons.add),
    //               onPressed: () {
    //                 print('before ' + (_currentPosition.toString()));
    //                 _currentPosition = _currentPosition.floorToDouble();
    //                 _updatePosition(min(
    //                   ++_currentPosition,
    //                   _totalDots.toDouble(),
    //                 ));
    //                 print('after ' + (_currentPosition.toString()));
    //               },
    //             )
    //           ]),
    //           // _buildRow([
    //           //   Text(
    //           //     'Vertical',
    //           //     style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18.0),
    //           //   ),
    //           //   Text(
    //           //     'Vertical reversed',
    //           //     style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18.0),
    //           //   ),
    //           // ]),
    //         ],
    //       ),
    //     ),
    //   );
    //   bottomWidgets.add(
    //     Align(
    //       alignment: Alignment.bottomCenter,
    //       child: new DotsIndicator(
    //         dotsCount: _totalDots,
    //         position: _currentPosition,
    //         decorator: DotsDecorator(
    //           size: const Size.square(9.0),
    //           activeSize: const Size(18.0, 9.0),
    //           activeShape: RoundedRectangleBorder(
    //             borderRadius: BorderRadius.circular(5.0),
    //           ),
    //         ),
    //       ),
    //     ),
    //   );
    // }

    bottomWidgets.add(
      Align(
        alignment: Alignment.bottomCenter,
        child: Stack(
          children: [
            ListView(
              physics: ScrollPhysics.,
              children: [
                ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      FloatingActionButton(
                        child: const Icon(Icons.remove),
                        onPressed: () {
                          print('before ' + (_currentPosition.toString()));
                          _currentPosition = _currentPosition.ceilToDouble();
                          _updatePosition(max(--_currentPosition, 0));
                          print('after ' + (_currentPosition.toString()));
                        },
                      ),
                      FloatingActionButton(
                        child: const Icon(Icons.add),
                        onPressed: () {
                          print('before ' + (_currentPosition.toString()));
                          _currentPosition = _currentPosition.floorToDouble();
                          _updatePosition(min(
                            ++_currentPosition,
                            _totalDots.toDouble(),
                          ));
                          print('after ' + (_currentPosition.toString()));
                        },
                      )
                    ],
                  ),
                ),
                // _buildRow([
                //   Text(
                //     'Vertical',
                //     style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18.0),
                //   ),
                //   Text(
                //     'Vertical reversed',
                //     style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18.0),
                //   ),
                // ]),
                // title: Align(
                //     alignment: Alignment.bottomCenter,
                //     child: Row(
                ListTile(
                  title: new DotsIndicator(
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
            )
          ],
          //  ),
        ),
      ),
    );
    // bottomWidgets.add(
    //   Align(
    //     alignment: Alignment.bottomCenter,
    //     child: new DotsIndicator(
    //       dotsCount: _totalDots,
    //       position: _currentPosition,
    //       decorator: DotsDecorator(
    //         size: const Size.square(9.0),
    //         activeSize: const Size(18.0, 9.0),
    //         activeShape: RoundedRectangleBorder(
    //           borderRadius: BorderRadius.circular(5.0),
    //         ),
    //       ),
    //     ),
    //   ),
    // );

    return bottomWidgets;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Dots indicator example'),
        ),
        body: Stack(
          children: _bottom(),
        ),
      ),
    );
  }
}
