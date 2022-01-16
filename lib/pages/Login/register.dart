import 'dart:math';
import 'package:connectivity/connectivity.dart';
import 'package:contact_tracing/pages/Login/login.dart';
import 'package:contact_tracing/providers/notificationbadgemanager.dart';
import 'package:contact_tracing/services/auth.dart';
import 'package:contact_tracing/services/databaseServices.dart';
import 'package:contact_tracing/services/globals.dart';
import 'package:contact_tracing/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:geocoder/geocoder.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:contact_tracing/pages/Mobile/mobiles.dart';
import 'package:contact_tracing/widgets/commonWidgets.dart';
import 'package:provider/provider.dart';

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

  late var _subscription;
  bool _internetConnection = true;

  late bool? _emailInDB;
  String _dateOfBirth = '';
  // DefaultCountry _defaultCountry;

  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  bool _invalidFirstName = false;
  bool _invalidLastName = false;
  bool _invalidAddress = false;
  bool _invalidemail = false;
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

  _insertMYSQL() async {
    final data = await DatabaseMySQLServices.registerUser(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        address: _addressController.text.trim(),
        dateOfBirth: _dateOfBirth,
        email: _emailController.text.trim());
    if (data != 'Error') {
      if (data['msg'] == 'email already existed') {
        var msg = 'email already taken please change the email or login.';
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
        await GlobalVariables.setEmail(email: _emailController.text.trim());

        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => MobilePage()));
      }
    } else {
      setState(() {
        _showReload = true;
      });
    }
  }

  void _submit() async {
    if (_passwordController.text.isEmpty) {
      setState(() {
        _invalidPassword = true;
      });
    }
    if ((_passwordController.text != _confirmPasswordController.text) ||
        (_confirmPasswordController.text.isEmpty)) {
      setState(() {
        _invalidConfirmPassword = true;
      });
    }
    if (_emailController.text.isEmpty || _emailInDB!) {
      setState(() {
        _invalidemail = true;
      });
    }

    if ((_invalidPassword == false) ||
        (_invalidConfirmPassword == false) ||
        (_invalidemail == false)) {
      setState(() {
        _isLoading = true;
      });

      final response = await FirebaseAuthenticate().firebaseRegisterUser(
        email: _emailController.text.trim(),
        password: _confirmPasswordController.text.trim(),
      );

      if (response == true) {
        print('response is true');
        //means that firebase already have the username then add the username to mysql
        await _insertMYSQL();
      } else {
        print('cannot register on firebase');
        //cannot register on firebase
        if ((FirebaseAuthenticate().geterrors().code) ==
            'email-already-in-use') {
          print('email already exist error code');
          //means that either using other persons mail or have not inserted to mysql
          bool firebaseLoggedIn =
              await FirebaseAuthenticate().firebaseLoginUser(
            email: _emailController.text,
            password: _confirmPasswordController.text,
          );
          if (firebaseLoggedIn == true) {
            //if can login to firebase with the user credential -- sql not inserted
            await _insertMYSQL();
            setState(() {
              _isLoading = false;
            });
          } else {
            print('you are trying to use other person account');
            //trying to use other persons mail
            DialogBox.showErrorDialog(
              context: context,
              title: FirebaseAuthenticate().geterrors().code,
              body: FirebaseAuthenticate().geterrors().message!,
            );
            setState(() {
              _isLoading = false;
            });
          }
        } else {
          DialogBox.showErrorDialog(
            context: context,
            title: FirebaseAuthenticate().geterrors().code,
            body: FirebaseAuthenticate().geterrors().message!,
          );
          setState(() {
            _isLoading = false;
          });
        }
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  _buildemailTile() {
    if (_emailInDB == true) {
      return Icon(
        Icons.cancel_outlined,
        color: Colors.red,
      );
    } else if (_emailInDB == false) {
      return Icon(
        Icons.done,
        color: Colors.green,
      );
    } else {
      return CircularProgressIndicator();
    }
  }

  _checkEmail(String email) async {
    // Null or empty string is invalid
    if (email == null || email.isEmpty) {
      return false;
    }

    const pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    final regExp = RegExp(pattern);

    if (!regExp.hasMatch(email)) {
      setState(() {
        _emailInDB = true;
      });
      return false;
    } else {
      bool? emailExist = await FirebaseAuthenticate().emailExist(
        email: email,
      );
      setState(() {
        _emailInDB = emailExist;
      });
      return true;
    }
    // // setState(() {
    // //   _emailInDB = null;
    // // });
    // String text = _emailController.text;
    // try {
    //   final res = await http.post(
    //     Uri.parse(checkEmailUrl),
    //     body: {'email': text},
    //   );
    //   final data = jsonDecode(res.body);

    //   if (data['msg'] == 'email already in db') {
    //     print(data['msg']);
    //     setState(() {
    //       _emailInDB = true;
    //     });
    //   } else if (data['msg'] == 'email not in db') {
    //     print(data['msg']);
    //     setState(() {
    //       _emailInDB = false;
    //     });
    //   } else {
    //     setState(() {
    //       _emailInDB = null;
    //     });
    //   }
    // } on Exception {
    //   setState(() {
    //     _emailInDB = null;
    //   });
    // }
  }

  Future _fillAddresses() async {
    try {
      await Geolocator.requestPermission();
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: geolocatorAccuracy);

      final coordinates =
          new Coordinates(position.latitude, position.longitude);
      final addresses =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
      final instance = addresses.first;
      setState(() {
        _addressController.text = (instance.locality +
            ', ' +
            instance.adminArea +
            ', ' +
            instance.countryName);
      });
    } on Exception {
      print('problem in try');
    }
  }

  Widget _dots() {
    return new DotsIndicator(
      dotsCount: _totalDots,
      position: _currentPosition,
      decorator: DotsDecorator(
        activeColor: Theme.of(context).colorScheme.secondary,
        //  color: Theme.of(context).colorScheme.primary,
        // color: Theme.of(context).primaryColorDark,
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
                    itemTextStyle: TextStyle(
                      fontSize: 19,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
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
              controller: _addressController,
              decoration: new InputDecoration(
                labelText: 'Address',
                errorText: _invalidAddress ? 'Address Can\'t Be Empty' : null,
              ),
            ),
          ),
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
          (_emailController.text == '' || _emailController.text == null)
              ? ListTile(
                  title: TextField(
                    controller: _emailController,
                    decoration: new InputDecoration(
                      labelText: 'Email',
                      errorText: _invalidemail ? 'Email Can\'t Be Empty' : null,
                    ),
                    onChanged: (String s) {
                      print(s);
                      setState(() {
                        _emailInDB = null;
                        _checkEmail(s);
                        _invalidemail = s.isEmpty ? true : false;
                      });
                    },
                  ),
                )
              : ListTile(
                  title: TextField(
                    controller: _emailController,
                    decoration: new InputDecoration(
                      labelText: 'Email',
                      errorText: _invalidemail ? 'Email Can\'t Be Empty' : null,
                    ),
                    onChanged: (String s) {
                      setState(() {
                        _emailInDB = null;
                        _checkEmail(s);
                      });
                      print(s);
                    },
                  ),
                  trailing: _buildemailTile(),
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
                  _invalidPasswordMessage = (_validatePassword(s) != null)
                      ? _validatePassword(s) as String
                      : '';
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
      return _f1(); //firstname, lastname
    } else if (_currentPosition == 1.0) {
      setState(() {
        _firstNameController.text.isEmpty
            ? _invalidFirstName = true
            : _invalidFirstName = false;
        _lastNameController.text.isEmpty
            ? _invalidLastName = true
            : _invalidLastName = false;
        // (_isEmail(_emailController.text.trim()))
        //     ? _invalidEmail = false
        //     : _invalidEmail = true;
      });
      if (_invalidFirstName || _invalidLastName) {
        print('before ' + (_currentPosition.toString()));
        _currentPosition = _currentPosition.ceilToDouble();
        _updatePosition(max(--_currentPosition, 0));
        print('after ' + (_currentPosition.toString()));
        return _f1();
      }
      // _emailController.text = _firstNameController.text.trim() +
      //     ' ' +
      //     _lastNameController.text.trim();
      // _checkemail();
      return _f2(); //dob
    } else if (_currentPosition == 2.0) {
      return _f3(); //country, address
    } else if (_currentPosition == 3.0) {
      setState(() {
        // if (_defaultCountry.toString().isEmpty) {
        //   _showdialogInvalidCountry();
        // }
        // _nationalIdNumberController.text.isEmpty
        //     ? _invalidNIC = true
        //     : _invalidNIC = false;
        _addressController.text.isEmpty
            ? _invalidAddress = true
            : _invalidAddress = false;
      });
      // if (_invalidNIC || _invalidAddress) {
      if (_invalidAddress) {
        print('before ' + (_currentPosition.toString()));
        _currentPosition = _currentPosition.ceilToDouble();
        _updatePosition(max(--_currentPosition, 0));
        print('after ' + (_currentPosition.toString()));
        return _f3();
      }
      return _f4(); //email, password, confirm password
    } else {
      return Container();
    }
  }

  Widget _body() {
    if (_internetConnection == false) {
      return Aesthetic.displayNoConnection();
    } else {
      if (_isLoading == true) {
        return Aesthetic.displayCircle();
      } else if (_showReload == true) {
        return Center(
          child: FloatingActionButton(
            foregroundColor: Colors.red,
            backgroundColor: Theme.of(context).colorScheme.secondary,
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
  }

  Widget _loginButton() {
    return Container(
      child: TextButton(
        style: Theme.of(context).textButtonTheme.style,
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
                  SizedBox(
                    // width: 200,
                    child: new ElevatedButton(
                      style: Theme.of(context).elevatedButtonTheme.style,
                      child: new Text('Next'),
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
                  )
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
                  ElevatedButton(
                    style: Theme.of(context).elevatedButtonTheme.style,
                    child: Text(
                      'Previous',
                    ),
                    onPressed: () {
                      print('before ' + (_currentPosition.toString()));
                      _currentPosition = _currentPosition.ceilToDouble();
                      _updatePosition(max(--_currentPosition, 0));
                      print('after ' + (_currentPosition.toString()));
                    },
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.green),
                    ),
                    child: Text(
                      'Submit',
                      // style: TextStyle(
                      //   color: Theme.of(context).splashColor,
                      // ),
                    ),
                    onPressed: () {
                      _submit();
                    },
                  ),
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
                  ElevatedButton(
                    style: Theme.of(context).elevatedButtonTheme.style,
                    // style: TextButton.styleFrom(
                    //   backgroundColor: Colors.blue,
                    // ),
                    child: Text(
                      'Previous',
                      // style: TextStyle(
                      //   color: Colors.white,
                      // ),
                    ),
                    onPressed: () {
                      print('before ' + (_currentPosition.toString()));
                      _currentPosition = _currentPosition.ceilToDouble();
                      _updatePosition(max(--_currentPosition, 0));
                      print('after ' + (_currentPosition.toString()));
                    },
                  ),
                  ElevatedButton(
                    style: Theme.of(context).elevatedButtonTheme.style,
                    // style: TextButton.styleFrom(
                    //   backgroundColor: Colors.blue,
                    // ),
                    child: Text(
                      'Next',
                      // style: TextStyle(
                      //   color: Colors.white,
                      // ),
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
    _subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      print(result);
      if (result == ConnectivityResult.none) {
        setState(() {
          _internetConnection = false;
        });
      } else {
        setState(() {
          _internetConnection = true;
        });
      }
    });
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
    return Container(
      // color: Colors.white,
      child: SafeArea(
        top: true,
        bottom: true,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Register"),
            centerTitle: true,
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
          drawer: buildDrawer(context, LoginPage.route),
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
      ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _subscription.cancel();
    super.dispose();
  }

  @override
  void deactivate() {
    _subscription.cancel();
    super.deactivate();
  }
}
