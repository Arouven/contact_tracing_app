import 'dart:math';

import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';

class RegisterDotsPage extends StatefulWidget {
  static const String route = '/registerDots';
  @override
  _RegisterDotsState createState() => _RegisterDotsState();
}

class _RegisterDotsState extends State<RegisterDotsPage> {
  final _totalDots = 5;
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

  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _nationalIdNumberController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  double _validPosition(double position) {
    if (position >= _totalDots) return 0;
    if (position < 0) return _totalDots - 1.0;
    return position;
  }

  void _updatePosition(double position) {
    setState(() => _currentPosition = _validPosition(position));
  }

  String getCurrentPositionPretty() {
    return (_currentPosition + 1.0).toStringAsPrecision(2);
  }

  Widget _bottom() {
    if (_currentPosition == 0.0) {
      return Container(
        child: ListView(
          shrinkWrap: true,
          children: [
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: Text(
                      'Next',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
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
        ),
      );
    } else if (_currentPosition == 4.0) {
      return Container(
        child: ListView(
          shrinkWrap: true,
          children: [
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: Text(
                      'Previous',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      print('before ' + (_currentPosition.toString()));
                      _currentPosition = _currentPosition.ceilToDouble();
                      _updatePosition(max(--_currentPosition, 0));
                      print('after ' + (_currentPosition.toString()));
                    },
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: Text(
                      'Submit',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      _submit();
                      print('Submit the form ');
                    },
                  )
                ],
              ),
            ),
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
        ),
      );
    } else {
      return Container(
        child: ListView(
          shrinkWrap: true,
          children: [
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: Text(
                      'Previous',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      print('before ' + (_currentPosition.toString()));
                      _currentPosition = _currentPosition.ceilToDouble();
                      _updatePosition(max(--_currentPosition, 0));
                      print('after ' + (_currentPosition.toString()));
                    },
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: Text(
                      'Next',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
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
        ),
      );
    }
  }

  DateTime _initialDate(_dateParse) {
    if (_dateOfBirth == null || _dateOfBirth == '') {
      return DateTime(_dateParse.year - 18, 01, 01);
    } else {
      try {
        var existing = DateTime.parse(_dateOfBirth);
        return DateTime(existing.year, existing.month, existing.day);
      } on Exception {
        return DateTime(_dateParse.year - 18, 01, 01);
      }
    }
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

  _submit() {}

  Widget _f1() {
    return Container(
      child: ListView(
        shrinkWrap: true,
        physics: AlwaysScrollableScrollPhysics(),
        children: [
          ListTile(
            title: TextField(
              controller: _firstNameController,
              decoration: new InputDecoration(labelText: 'First Name'),
              onChanged: (String _) {
                _firstName = _firstNameController.text;
              },
            ),
          ),
          ListTile(
            title: TextField(
              controller: _lastNameController,
              decoration: new InputDecoration(labelText: 'Last Name'),
              onChanged: (String _) {
                _lastName = _lastNameController.text;
              },
            ),
          ),
          ListTile(
            title: TextField(
              controller: _emailController,
              decoration: new InputDecoration(labelText: 'Email'),
              onChanged: (String _) {
                _email = _emailController.text;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _f2() {
    return Container(
      child: ListView(
        shrinkWrap: true,
        physics: AlwaysScrollableScrollPhysics(),
        children: [
          ListTile(
            title: TextField(
              controller: _firstNameController,
              decoration: new InputDecoration(labelText: 'First Name'),
            ),
          ),
          ListTile(
            title: TextField(
              controller: _lastNameController,
              decoration: new InputDecoration(labelText: 'Last Name'),
            ),
          ),
          ListTile(
            title: TextField(
              controller: _emailController,
              decoration: new InputDecoration(labelText: 'Email'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _f3() {
    var date = new DateTime.now().toString();
    print(date.toString());
    var _dateParse = DateTime.parse(date);
    if (_dateOfBirth == null || _dateOfBirth == '') {
      _dateOfBirth = date.toString();
    }
    return SingleChildScrollView(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          new Container(
            child: new Text(
              'Date of birth',
              style: TextStyle(
                fontSize: 40.0,
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 2, // / 1.3,
            child: Center(
              child: new Container(
                alignment: Alignment.center,
                child: new DatePickerWidget(
                  looping: true, // default is not looping
                  lastDate: DateTime(
                      _dateParse.year, _dateParse.month, _dateParse.day),

                  initialDate: _initialDate(_dateParse),
                  dateFormat: "dd-MMM-yyyy",
                  locale: DatePicker.localeFromString('en'),
                  onChange: (DateTime newDate, _) {
                    _dateOfBirth = newDate.toString();
                    print(_dateOfBirth);
                  },
                  pickerTheme: DateTimePickerTheme(
                    itemTextStyle: TextStyle(color: Colors.black, fontSize: 19),
                    dividerColor: Colors.blue,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _f4() {
    return Container(
      child: ListView(
        shrinkWrap: true,
        physics: AlwaysScrollableScrollPhysics(),
        children: [
          ListTile(
            title: TextField(
              controller: _nationalIdNumberController,
              decoration: new InputDecoration(labelText: 'NIC'),
              onChanged: (String _) {
                _nationalIdNumber = _nationalIdNumberController.text;
              },
            ),
          ),
          ListTile(
            title: TextField(
              maxLines: 2,
              controller: _addressController,
              decoration: new InputDecoration(labelText: 'Address'),
              onChanged: (String _) {
                _address = _addressController.text;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _f5() {
    return Container(
      child: ListView(
        shrinkWrap: true,
        physics: AlwaysScrollableScrollPhysics(),
        children: [
          ListTile(
            title: TextField(
              controller: _usernameController,
              decoration: new InputDecoration(labelText: 'Username'),
              onChanged: (String _) {
                _username = _usernameController.text;
              },
            ),
          ),
          ListTile(
            title: TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: new InputDecoration(labelText: 'Password'),
              onChanged: (String _) {
                _password = _passwordController.text;
              },
            ),
          ),
          ListTile(
            title: TextField(
              controller: _emailController,
              decoration: new InputDecoration(labelText: 'Email'),
              onChanged: (String _) {
                _email = _emailController.text;
              },
            ),
          ),
        ],
      ),
    );
  }

  _body() {
    print(_firstName);
    print(_lastName);
    print(_email);
    print(_country);
    print(_dateOfBirth);
    print(_nationalIdNumber);
    print(_address);
    print(_username);
    print(_password);
// setState(() {

// });
    if (_currentPosition == 0.0) {
      return _f1(); //firstname, lastname, email
    } else if (_currentPosition == 1.0) {
      return _f2(); //country
    } else if (_currentPosition == 2.0) {
      return _f3(); //dob
    } else if (_currentPosition == 3.0) {
      return _f4(); //nic, address
    } else if (_currentPosition == 4.0) {
      return _f5(); //username, password
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Register'),
        ),
        body: _body(),
        bottomNavigationBar: Container(
          child: _bottom(),
        ),
      ),
    );
  }
}
