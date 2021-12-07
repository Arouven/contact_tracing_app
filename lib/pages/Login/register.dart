import 'dart:convert';
import 'dart:math';
import 'package:contact_tracing/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';
import 'package:contact_tracing/classes/globals.dart';
import 'package:contact_tracing/pages/Mobile/mobiles.dart';
import 'package:contact_tracing/widgets/commonWidgets.dart';

class RegisterPage extends StatefulWidget {
  static const String route = '/register';
  @override
  _RegisterState createState() {
    print("in register");
    return _RegisterState();
  }
}

class _RegisterState extends State<RegisterPage> {
  final _totalDots = 4;
  double _currentPosition = 0.0;
  bool _isLoading = true;
  bool _showReload = false;

  late bool? _usernameInDB;
  String _dateOfBirth = '';
  // DefaultCountry _defaultCountry;

  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _nationalIdNumberController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  bool _invalidFirstName = false;
  bool _invalidLastName = false;
  bool _invalidEmail = false;
  bool _invalidNIC = false;
  bool _invalidAddress = false;
  bool _invalidUserName = false;
  bool _invalidPassword = false;
  bool _invalidConfirmPassword = false;

  String _invalidPasswordMessage = 'Please enter password';

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

  DateTime _initialDate(DateTime _dateNow) {
    if (_dateOfBirth == null || _dateOfBirth == '') {
      print('no dob in var');
      var dob = DateTime(_dateNow.year - 18, _dateNow.month, _dateNow.day);
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
        return DateTime(_dateNow.year - 18, _dateNow.month, _dateNow.day);
      }
    }
  }

  void _submit() async {
    if (_confirmPasswordController.text.isEmpty) {
      setState(() {
        _invalidConfirmPassword = true;
      });
    } else if (_passwordController.text.isEmpty) {
      setState(() {
        _invalidPassword = true;
      });
    } else if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _invalidConfirmPassword = true;
      });
    } else if (_usernameController.text.isEmpty || _usernameInDB!) {
      setState(() {
        _invalidUserName = true;
      });
    } else {
      setState(() {
        _isLoading = true;
      });
      var _firstName = _firstNameController.text.trim();
      var _lastName = _lastNameController.text.trim();
      var _email = _emailController.text.trim();
      var _nationalIdNumber = _nationalIdNumberController.text.trim();
      var _address = _addressController.text.trim();
      var _username = _usernameController.text.trim();
      var _password = _confirmPasswordController.text.trim();
      //  var _country = _defaultCountry.toString().split('.').last;

      try {
        final res = await http.post(
          Uri.parse(registerUrl),
          body: {
            'firstName': _firstName,
            'lastName': _lastName,
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
          var msg =
              'Username already taken please change the username or login.';
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
  }

  _buildUsernameTile() {
    if (_usernameInDB == true) {
      return Icon(
        Icons.cancel_outlined,
        color: Colors.red,
      );
    } else if (_usernameInDB == false) {
      return Icon(
        Icons.done,
        color: Colors.green,
      );
    } else {
      return CircularProgressIndicator();
    }
  }

  _checkUsername() async {
    // setState(() {
    //   _usernameInDB = null;
    // });
    String text = _usernameController.text;
    try {
      final res = await http.post(
        Uri.parse(checkUsernameUrl),
        body: {'username': text},
      );
      final data = jsonDecode(res.body);

      if (data['msg'] == 'username already in db') {
        print(data['msg']);
        setState(() {
          _usernameInDB = true;
        });
      } else if (data['msg'] == 'username not in db') {
        print(data['msg']);
        setState(() {
          _usernameInDB = false;
        });
      } else {
        setState(() {
          _usernameInDB = null;
        });
      }
    } on Exception {
      setState(() {
        _usernameInDB = null;
      });
    }
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
      // var countryName = instance.countryName;
      // String withUnderscore = countryName.replaceAll(' ', '_');
      // DefaultCountry country;
      // for (DefaultCountry c in DefaultCountry.values) {
      //   String countryValue = c.toString().split('.').last;
      //   if (countryValue == withUnderscore) {
      //     country = c;
      //     break;
      //   }
      // }
      setState(() {
        // _defaultCountry = country;
        _addressController.text = (instance.locality +
            ', ' +
            instance.adminArea +
            ', ' +
            instance.countryName);
      });
    } on Exception {
      print('problem in try');
      // setState(() {
      //   _defaultCountry = null;
      // });
    }
  }

  Widget _dots() {
    return new DotsIndicator(
      dotsCount: _totalDots,
      position: _currentPosition,
      decorator: DotsDecorator(
        size: const Size.square(9.0),
        activeSize: const Size(18.0, 9.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
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
              decoration: new InputDecoration(
                labelText: 'First Name',
                errorText:
                    _invalidFirstName ? 'First Name Can\'t Be Empty' : null,
              ),
            ),
          ),
          ListTile(
            title: TextField(
              controller: _lastNameController,
              decoration: new InputDecoration(
                labelText: 'Last Name',
                errorText:
                    _invalidLastName ? 'Last Name Can\'t Be Empty' : null,
              ),
            ),
          ),
          ListTile(
            title: TextField(
              controller: _emailController,
              decoration: new InputDecoration(
                labelText: 'Email',
                errorText: _invalidEmail ? 'Please enter a valid Email' : null,
              ),
            ),
          ),
          ListTile(
            title: _loginButton(),
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
          ListTile(
            title: _loginButton(),
          ),
        ],
      ),
    );
  }

  Widget _f3() {
    setState(() {
      _isLoading = true;
    });
    // print(_defaultCountry.toString());
    // String stateValue = "";
    // String cityValue = "";
    // String address = "";
    Widget out = Container(
      child: ListView(
        shrinkWrap: true,
        physics: AlwaysScrollableScrollPhysics(),
        children: [
          ListTile(
            title: TextField(
              controller: _nationalIdNumberController,
              decoration: new InputDecoration(
                labelText: 'NIC',
                errorText: _invalidNIC ? 'NIC Can\'t Be Empty' : null,
              ),
            ),
          ),
          ListTile(
            title: TextField(
              controller: _addressController,
              decoration: new InputDecoration(
                labelText: 'Address',
                errorText: _invalidAddress ? 'Address Can\'t Be Empty' : null,
              ),
            ),
          ),
          // ListTile(
          //   title: CSCPicker(
          //     ///Enable disable state dropdown [OPTIONAL PARAMETER]
          //     showStates: false,

          //     /// Enable disable city drop down [OPTIONAL PARAMETER]
          //     showCities: false,

          //     ///Enable (get flag with country name) / Disable (Disable flag) / ShowInDropdownOnly (display flag in dropdown only) [OPTIONAL PARAMETER]
          //     flagState: CountryFlag.ENABLE,

          //     ///Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER] (USE with disabledDropdownDecoration)
          //     dropdownDecoration: BoxDecoration(
          //         borderRadius: BorderRadius.all(Radius.circular(10)),
          //         color: Colors.white,
          //         border: Border.all(color: Colors.grey.shade300, width: 1)),

          //     ///Disabled Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER]  (USE with disabled dropdownDecoration)
          //     disabledDropdownDecoration: BoxDecoration(
          //         borderRadius: BorderRadius.all(Radius.circular(10)),
          //         color: Colors.grey.shade300,
          //         border: Border.all(color: Colors.grey.shade300, width: 1)),

          //     ///placeholders for dropdown search field
          //     countrySearchPlaceholder: "Country",
          //     stateSearchPlaceholder: "State",
          //     citySearchPlaceholder: "City",

          //     ///labels for dropdown
          //     countryDropdownLabel: "*Country",
          //     stateDropdownLabel: "*State",
          //     cityDropdownLabel: "*City",

          //     defaultCountry: _defaultCountry,

          //     ///selected item style [OPTIONAL PARAMETER]
          //     selectedItemStyle: TextStyle(
          //       color: Colors.black,
          //       fontSize: 14,
          //     ),

          //     ///DropdownDialog Heading style [OPTIONAL PARAMETER]
          //     dropdownHeadingStyle: TextStyle(
          //         color: Colors.black,
          //         fontSize: 17,
          //         fontWeight: FontWeight.bold),

          //     ///DropdownDialog Item style [OPTIONAL PARAMETER]
          //     dropdownItemStyle: TextStyle(
          //       color: Colors.black,
          //       fontSize: 14,
          //     ),

          //     ///Dialog box radius [OPTIONAL PARAMETER]
          //     dropdownDialogRadius: 10.0,

          //     ///Search bar radius [OPTIONAL PARAMETER]
          //     searchBarRadius: 10.0,

          //     ///triggers once country selected in dropdown
          //     onCountryChanged: (countryWithIcon) {
          //       var countryName = countryWithIcon.split('    ');
          //       String withUnderscore = countryName[1].replaceAll(' ', '_');
          //       for (DefaultCountry country in DefaultCountry.values) {
          //         String countryValue = country.toString().split('.').last;
          //         if (countryValue == withUnderscore) {
          //           setState(() {
          //             _defaultCountry = country;
          //           });
          //           break;
          //         }
          //       }
          //     },

          //     ///triggers once state selected in dropdown
          //     onStateChanged: (value) {
          //       setState(() {
          //         ///store value in state variable
          //         stateValue = value;
          //       });
          //     },

          //     ///triggers once city selected in dropdown
          //     onCityChanged: (value) {
          //       setState(() {
          //         //store value in city variable
          //         cityValue = value;
          //       });
          //     },
          //   ),
          // ),
          ListTile(
            title: _loginButton(),
          ),
        ],
      ),
    );

    // await Future.delayed(const Duration(seconds: 2), () {});
    setState(() {
      _isLoading = false;
    });
    return out;
  }

  Widget _f4() {
    return Container(
      child: ListView(
        shrinkWrap: true,
        physics: AlwaysScrollableScrollPhysics(),
        children: [
          (_usernameController.text == '' || _usernameController.text == null)
              ? ListTile(
                  title: TextField(
                    controller: _usernameController,
                    decoration: new InputDecoration(
                      labelText: 'Username',
                      errorText:
                          _invalidUserName ? 'User Name Can\'t Be Empty' : null,
                    ),
                    onChanged: (String s) {
                      print(s);
                      setState(() {
                        _usernameInDB = null;
                        _checkUsername();
                        s.isEmpty
                            ? _invalidUserName = true
                            : _invalidUserName = false;
                      });
                    },
                  ),
                )
              : ListTile(
                  title: TextField(
                    controller: _usernameController,
                    decoration: new InputDecoration(
                      labelText: 'Username',
                      // errorText:
                      //     _invalidUserName ? 'User Name Can\'t Be Empty' : null,
                    ),
                    onChanged: (String s) {
                      setState(() {
                        _usernameInDB = null;
                        _checkUsername();
                      });
                      // _checkUsername();
                      print(s);
                      // setState(() {
                      //   s.isEmpty
                      //       ? _invalidUserName = true
                      //       : _invalidUserName = false;
                      // });
                    },
                  ),
                  trailing: _buildUsernameTile(),
                ),
          ListTile(
            title: TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: new InputDecoration(
                labelText: 'Password',
                errorText: _invalidPassword ? _invalidPasswordMessage : null,
              ),
              onChanged: (String s) {
                setState(() {
                  if (s.isEmpty) {
                    _invalidPassword = true;
                  } else {
                    _invalidPassword = false;
                  }
                  _invalidPasswordMessage = _validatePassword(s)!;
                });
              },
            ),
          ),
          ListTile(
            title: TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: new InputDecoration(
                labelText: 'Confirm Password',
                errorText:
                    _invalidConfirmPassword ? 'Password does not match' : null,
              ),
              onChanged: (String _) {
                if (_confirmPasswordController.text !=
                    _passwordController.text) {
                  setState(() {
                    _invalidConfirmPassword = true;
                  });
                } else {
                  setState(() {
                    _invalidConfirmPassword = false;
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  String? _validatePassword(String value) {
//     r'^
//   (?=.*[A-Z])       // should contain at least one upper case
//   (?=.*[a-z])       // should contain at least one lower case
//   (?=.*?[0-9])      // should contain at least one digit
//   (?=.*?[!@#\$&*~]) // should contain at least one Special character
//   .{8,}             // Must be at least 8 characters in length
// $

    // Pattern pattern =
    //     r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regexupper = new RegExp(r'^(?=.*?[A-Z])');
    RegExp regexlower = new RegExp(r'^(?=.*?[a-z])');
    RegExp regexdigit = new RegExp(r'^(?=.*?[0-9])');
    RegExp regexspecial = new RegExp(r'^(?=.*?[!@#\$&*~£%^()+-/|<>,.])');
    RegExp regexlength = new RegExp(r'^.{8,}$');
    print(value);
    if (value.isEmpty) {
      setState(() {
        _invalidPassword = true;
      });
      return 'Please enter password';
    } else {
      if (!regexupper.hasMatch(value)) {
        setState(() {
          _invalidPassword = true;
        });
        print('No Upper case found');
        return 'No Upper case found';
      } else if (!regexlower.hasMatch(value)) {
        setState(() {
          _invalidPassword = true;
        });
        print('No Lower case found');
        return 'No Lower case found';
      } else if (!regexdigit.hasMatch(value)) {
        setState(() {
          _invalidPassword = true;
        });
        print('No digit found');
        return 'No digit found';
      } else if (!regexspecial.hasMatch(value)) {
        setState(() {
          _invalidPassword = true;
        });
        print('No special charactor found');
        return 'No special charactor found';
      } else if (!regexlength.hasMatch(value)) {
        setState(() {
          _invalidPassword = true;
        });
        print('8 char');
        return 'Password must be at least 8 charactors';
      } else {
        setState(() {
          _invalidPassword = false;
        });
        print('good password');
        return null;
      }
    }
  }

  bool _isEmail(String string) {
    // Null or empty string is invalid
    if (string == null || string.isEmpty) {
      return false;
    }

    const pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    final regExp = RegExp(pattern);

    if (!regExp.hasMatch(string)) {
      return false;
    }
    return true;
  }

  // void _showdialogInvalidCountry() {
  //   DialogBox.showErrorDialog(
  //     context: context,
  //     title: 'Select a country',
  //     body: 'Please select a country',
  //   );
  // }

  Widget _form() {
    if (_currentPosition == 0.0) {
      //return _f4();
      return _f1(); //firstname, lastname, email
    } else if (_currentPosition == 1.0) {
      setState(() {
        _firstNameController.text.isEmpty
            ? _invalidFirstName = true
            : _invalidFirstName = false;
        _lastNameController.text.isEmpty
            ? _invalidLastName = true
            : _invalidLastName = false;
        (_isEmail(_emailController.text.trim()))
            ? _invalidEmail = false
            : _invalidEmail = true;
      });
      if (_invalidFirstName || _invalidLastName || _invalidEmail) {
        print('before ' + (_currentPosition.toString()));
        _currentPosition = _currentPosition.ceilToDouble();
        _updatePosition(max(--_currentPosition, 0));
        print('after ' + (_currentPosition.toString()));
        return _f1();
      }
      _usernameController.text = _firstNameController.text.trim() +
          ' ' +
          _lastNameController.text.trim();
      _checkUsername();
      return _f2(); //dob
    } else if (_currentPosition == 2.0) {
      return _f3(); //country, nic, address
    } else if (_currentPosition == 3.0) {
      setState(() {
        // if (_defaultCountry.toString().isEmpty) {
        //   _showdialogInvalidCountry();
        // }
        _nationalIdNumberController.text.isEmpty
            ? _invalidNIC = true
            : _invalidNIC = false;
        _addressController.text.isEmpty
            ? _invalidAddress = true
            : _invalidAddress = false;
      });
      if (_invalidNIC || _invalidAddress) {
        print('before ' + (_currentPosition.toString()));
        _currentPosition = _currentPosition.ceilToDouble();
        _updatePosition(max(--_currentPosition, 0));
        print('after ' + (_currentPosition.toString()));
        return _f3();
      }
      return _f4(); //username, password, confirm password
    } else {
      return Container();
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

  Widget _loginButton() {
    return Container(
      child: TextButton(
        child: Text('Already have an account? Tap here to login.'),
        onPressed: () {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => LoginPage()));
        },
      ),
    );
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
                  ),
                ],
              ),
              subtitle: _dots(),
            ),
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
                    },
                  )
                ],
              ),
              subtitle: _dots(),
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
              subtitle: _dots(),
            ),
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
        body: Column(
          children: [
            Expanded(
              child: _body(),
            ),
            Container(
              child: _bottom(),
            )
          ],
        ),
      ),
    );
  }
}
