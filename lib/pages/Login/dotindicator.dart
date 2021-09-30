import 'dart:convert';
import 'dart:math';

import 'package:contact_tracing/classes/globals.dart';
import 'package:contact_tracing/pages/Mobile/mobiles.dart';
import 'package:contact_tracing/widgets/commonWidgets.dart';
import 'package:contact_tracing/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';
//import 'package:country_list_pick/country_list_pick.dart';
//import 'package:flutter_country_picker/country.dart';

import 'package:http/http.dart' as http;
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
//import 'package:flutter/services.dart';
//import 'package:country_codes/country_codes.dart';
//import 'package:country_code/country_code.dart' as ccode;
import 'package:csc_picker/csc_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';
// import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  static const String route = '/register';
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<RegisterPage> {
  final _totalDots = 4;
  double _currentPosition = 0.0;
  bool _isLoading = true;
  bool _showReload = false;

  var _dateOfBirth = '';
  //bool _gatherLocattionFromButton = false;
  DefaultCountry _defaultCountry;

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

  DateTime _initialDate(_dateNow) {
    if (_dateOfBirth == null || _dateOfBirth == '') {
      print('no dob in var');
      var dob = DateTime(_dateNow.year - 18, 01, 01);
      _dateOfBirth = dob.toString();
      print(_dateOfBirth);
      return dob;
    } else {
      try {
        var existing = DateTime.parse(_dateOfBirth);
        print('already have dob in var');
        return DateTime(existing.year, existing.month, existing.day);
      } on Exception {
        print('exception');
        return DateTime(_dateNow.year - 18, 01, 01);
      }
    }
  }

  _submit() async {
    setState(() {
      _isLoading = true;
    });
    var _firstName = _firstNameController.text;
    var _lastName = _lastNameController.text;
    var _email = _emailController.text;
    var _nationalIdNumber = _nationalIdNumberController.text;
    var _address = _addressController.text;
    var _username = _usernameController.text;
    var _password = _passwordController.text;
    var _country = _defaultCountry.toString().split('.').last;

    try {
      final res = await http.post(
        Uri.parse(registerUrl),
        body: {
          'firstName': _firstName,
          'lastName': _lastName,
          'country': _country,
          'address': _address,
          'email': _email,
          'dateOfBirth': _dateOfBirth,
          'nationalIdNumber': _nationalIdNumber,
          'username': _username,
          'password': _password
        },
      );
      //print(res.body);
      final data = jsonDecode(res.body);

      if (data['msg'] == 'username already existed') {
        var msg = 'Username already taken please change the username or login.';
        DialogBox.showErrorDialog(
          context: context,
          title: 'Already Exist',
          body: msg,
        );
        print(msg);
      } else if (data['msg'] == 'user inserted') {
        //user inserted
        //redirect to home
        print('user inserted');
        final SharedPreferences prefs = await SharedPreferences.getInstance();

        await prefs.setString('username', _username);
        await prefs.setString('password', _password);

        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => MobilePage()));
      }
    } on Exception {
      setState(() {
        _showReload = true;
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future _fillAddresses() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: geolocatorAccuracy);

      final coordinates =
          new Coordinates(position.latitude, position.longitude);
      final addresses =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
      final instance = addresses.first;
      var countryName = instance.countryName;
      String withUnderscore = countryName.replaceAll(' ', '_');
      DefaultCountry country;
      for (DefaultCountry c in DefaultCountry.values) {
        String countryValue = c.toString().split('.').last;
        if (countryValue == withUnderscore) {
          country = c;
          break;
        }
      }
      setState(() {
        _defaultCountry = country;
        _addressController.text =
            (instance.locality + ', ' + instance.adminArea);
      });
    } on Exception {
      print('problem in try');
      setState(() {
        _defaultCountry = null;
      });
    }
  }

  Widget _dots() {
    return ListTile(
      title: Container(
        child: Row(
          children: [
            Text('Already have an account? Tap'),
            TextButton(
              child: Text(' here '),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => LoginPage()));
              },
            ),
            Text('to login.'),
          ],
        ),
      ),
      subtitle: new DotsIndicator(
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
    );
  }

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

  Widget _f2() {
    var date = new DateTime.now().toString();
    print(date.toString());
    var _dateParse = DateTime.parse(date);

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

                  initialDate: _initialDate(_dateParse), //-18 yrs
                  dateFormat: "dd-MMM-yyyy",
                  locale: DatePicker.localeFromString('en'),
                  onChange: (DateTime newDate, _) {
                    _dateOfBirth = newDate.toString();
                    print(_dateOfBirth);
                  },
                  pickerTheme: DateTimePickerTheme(
                    backgroundColor: Colors.transparent,
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

  Widget _f3() {
    // String countryValue = "";
    //print(_gatherLocattionFromButton);
    print(_defaultCountry.toString());
    String stateValue = "";
    String cityValue = "";
    String address = "";

    //Widget countrypicker;

    return Container(
      child: ListView(
        shrinkWrap: true,
        physics: AlwaysScrollableScrollPhysics(),
        children: [
          ListTile(
            title: TextField(
              controller: _nationalIdNumberController,
              decoration: new InputDecoration(labelText: 'NIC'),
              // onChanged: (String _) {
              //   _nationalIdNumber = _nationalIdNumberController.text;
              // },
            ),
          ),
          ListTile(
            title: TextField(
              controller: _addressController,
              decoration: new InputDecoration(labelText: 'Address'),
              // onChanged: (String _) {
              //   _address = _addressController.text;
              // },
            ),
          ),
          ListTile(
            title: CSCPicker(
              ///Enable disable state dropdown [OPTIONAL PARAMETER]
              showStates: false,

              /// Enable disable city drop down [OPTIONAL PARAMETER]
              showCities: false,

              ///Enable (get flag with country name) / Disable (Disable flag) / ShowInDropdownOnly (display flag in dropdown only) [OPTIONAL PARAMETER]
              flagState: CountryFlag.ENABLE,

              ///Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER] (USE with disabledDropdownDecoration)
              dropdownDecoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300, width: 1)),

              ///Disabled Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER]  (USE with disabled dropdownDecoration)
              disabledDropdownDecoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.grey.shade300,
                  border: Border.all(color: Colors.grey.shade300, width: 1)),

              ///placeholders for dropdown search field
              countrySearchPlaceholder: "Country",
              stateSearchPlaceholder: "State",
              citySearchPlaceholder: "City",

              ///labels for dropdown
              countryDropdownLabel: "*Country",
              stateDropdownLabel: "*State",
              cityDropdownLabel: "*City",

              defaultCountry: _defaultCountry,

              ///Default Country
              // defaultCountry: DefaultCountry.india,

              ///Disable country dropdown (Note: use it with default country)
              //disableCountry: true,

              ///selected item style [OPTIONAL PARAMETER]
              selectedItemStyle: TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),

              ///DropdownDialog Heading style [OPTIONAL PARAMETER]
              dropdownHeadingStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontWeight: FontWeight.bold),

              ///DropdownDialog Item style [OPTIONAL PARAMETER]
              dropdownItemStyle: TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),

              ///Dialog box radius [OPTIONAL PARAMETER]
              dropdownDialogRadius: 10.0,

              ///Search bar radius [OPTIONAL PARAMETER]
              searchBarRadius: 10.0,

              ///triggers once country selected in dropdown
              onCountryChanged: (countryWithIcon) {
                var countryName = countryWithIcon.split('    ');
                String withUnderscore = countryName[1].replaceAll(' ', '_');
                for (DefaultCountry country in DefaultCountry.values) {
                  String countryValue = country.toString().split('.').last;
                  if (countryValue == withUnderscore) {
                    setState(() {
                      _defaultCountry = country;
                    });
                    break;
                  }
                }
              },

              ///triggers once state selected in dropdown
              onStateChanged: (value) {
                setState(() {
                  ///store value in state variable
                  stateValue = value;
                });
              },

              ///triggers once city selected in dropdown
              onCityChanged: (value) {
                setState(() {
                  //store value in city variable
                  cityValue = value;
                });
              },
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
              controller: _usernameController,
              decoration: new InputDecoration(labelText: 'Username'),
              // onChanged: (String _) {
              //   _username = _usernameController.text;
              // },
            ),
          ),
          ListTile(
            title: TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: new InputDecoration(labelText: 'Password'),
              // onChanged: (String _) {
              //   _password = _passwordController.text;
              // },
            ),
          ),
          ListTile(
            title: TextField(
              controller: _emailController,
              decoration: new InputDecoration(labelText: 'Email'),
              // onChanged: (String _) {
              //   _email = _emailController.text;
              // },
            ),
          ),
        ],
      ),
    );
  }

  Widget _form() {
    if (_currentPosition == 0.0) {
      return _f1(); //firstname, lastname, email
    } else if (_currentPosition == 1.0) {
      return _f2(); //dob
    } else if (_currentPosition == 2.0) {
      return _f3(); //country, nic, address
    } else if (_currentPosition == 3.0) {
      return _f4(); //username, password
    } else if (_currentPosition == 4.0) {
      _submit();
      return null;
    } else {
      return null;
    }
  }

  Widget _body() {
    if (_isLoading == true) {
      return Aesthetic.displayCircle();
    } else if (_showReload == true) {
      return Center(
        child: FloatingActionButton(
          foregroundColor: Colors.red,
          backgroundColor: Colors.white,
          child: Icon(Icons.replay),
          onPressed: () {
            _submit();
          },
        ),
      );
    } else {
      return _form();
    }
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
            _dots(),
          ],
        ),
      );
    } else if (_currentPosition == 3.0) {
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
            _dots(),
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
            _dots(),
          ],
        ),
      );
    }
  }

  @override
  void initState() {
    // _getCountry();
    _fillAddresses().then((value) {
      setState(() {
        _isLoading = false;
      });
    });
    print(_totalDots);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Register"),
          centerTitle: true,
          backgroundColor: Colors.blue,
          actions: (_currentPosition == 2.0)
              ? [
                  IconButton(
                    onPressed: () async {
                      _fillAddresses().then((value) {
                        setState(() {});
                      });
                    },
                    icon: Icon(Icons.location_on),
                  )
                ]
              : null,
        ),
        drawer: buildDrawer(context, RegisterPage.route),
        body: _body(),
        bottomNavigationBar: _bottom(),
      ),
    );
  }
}
