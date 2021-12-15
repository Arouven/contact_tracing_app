import 'dart:io';
import 'package:contact_tracing/services/auth.dart';
import 'package:contact_tracing/services/databaseServices.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'mobiles.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import '../../widgets/commonWidgets.dart';
import 'package:flutter_otp/flutter_otp.dart';

class AddMobilePage extends StatefulWidget {
  static const String route = '/addMobile';

  @override
  _AddMobilePageState createState() {
    print("in addMobile");
    return _AddMobilePageState();
  }
}

class _AddMobilePageState extends State<AddMobilePage> {
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  String _deviceData = "";
  bool _isLoading = true;
  bool _showReload = false;
  bool _validateName = false;
  bool _validateDescription = false;
  bool _validateNumber = false;
  String _numwithoutcode = '';
  String initialCountry = 'MU';
  PhoneNumber number = PhoneNumber(isoCode: 'MU');
  String _mobileNumber = '';

  TextEditingController _mobileNumberController = TextEditingController();
  TextEditingController _mobileName = TextEditingController();
  TextEditingController _mobileDescription = TextEditingController();

  Future<void> initPlatformState() async {
    String deviceData = "";
    try {
      if (Platform.isAndroid) {
        deviceData = (await deviceInfoPlugin.androidInfo).model.toString();
      } else if (Platform.isIOS) {
        deviceData = (await deviceInfoPlugin.iosInfo).model.toString();
      }
    } on PlatformException {
      deviceData = 'Error:';
    }
    if (!mounted) return;
    setState(() {
      _deviceData = deviceData;
    });
  }

  _addButtonPressed() async {
    print('add button pressed');
    setState(() {
      _isLoading = true;
    });
    Navigator.of(context).pop();

    String? firebaseuid = FirebaseAuthenticate().getfirebaseuid();
    String? fcmtoken = await FirebaseAuthenticate().getfirebasefcmtoken();
    final data = await DatabaseServices().addMobile(
      firebaseuid: firebaseuid!,
      mobileName: _mobileName.text.toString(),
      mobileDescription: _mobileDescription.text.toString(),
      mobileNumber: _mobileNumber.toString(),
      fcmtoken: fcmtoken!,
    );
    if (data != 'Error') {
      print(data);
      try {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => MobilePage(),
          ),
          (e) => false,
        );
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        print(e.toString());
      }
    } else {
      setState(() {
        _isLoading = false;
        _showReload = true;
      });
    }
  }

  Future<void> _showAcceptDialog() async {
    print(_validateName);
    print(_validateDescription);
    print(_validateNumber);
    print(_numwithoutcode.length);
    if (!_validateDescription && !_validateName && !_validateNumber) {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'Add Phone',
              style: TextStyle(color: Colors.orange),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  new Row(
                    children: [
                      Expanded(
                        child: Text(
                            'Are you sure you want to save the new phone?'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Add'),
                onPressed: () async {
                  await _addButtonPressed();
                },
              ),
            ],
          );
        },
      );
    } else {
      setState(() {
        _isLoading = false;
      });
      return null;
    }
  }

  Widget _displayMobile() {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Center(
        child: ListView(
          children: <Widget>[
            new Container(
              child: new Column(
                children: <Widget>[
                  new Container(
                      child: new Row(
                    children: <Widget>[
                      Expanded(
                        child: new TextField(
                          controller: _mobileName,
                          decoration: new InputDecoration(
                            labelText: 'Mobile Name',
                            errorText:
                                _validateName ? 'Name Can\'t Be Empty' : null,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.info),
                        color: Colors.black,
                        iconSize: 30.0,
                        alignment: Alignment.centerRight,
                        onPressed: () {
                          setState(() {
                            _mobileName.text = _deviceData;
                          });
                        },
                      ),
                    ],
                  )),
                  new Container(
                    child: new Row(
                      children: <Widget>[
                        Expanded(
                          child: new TextField(
                            controller: _mobileDescription,
                            decoration: new InputDecoration(
                              //border: OutlineInputBorder(),
                              labelText: 'Mobile Description',
                              errorText: _validateDescription
                                  ? 'Description Can\'t Be Empty'
                                  : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  new Container(
                    child: InternationalPhoneNumberInput(
                      inputDecoration: new InputDecoration(
                        labelText: 'Mobile Number',
                        errorText:
                            _validateNumber ? 'Number Can\'t Be Empty' : null,
                      ),
                      onInputChanged: (PhoneNumber number) {
                        String? pn = number.phoneNumber;
                        _numwithoutcode =
                            (pn!.substring(number.dialCode!.length, pn.length));
                        print(_numwithoutcode);
                        setState(() {
                          _numwithoutcode.length == 0
                              ? _validateNumber = true
                              : _validateNumber = false;
                          _mobileNumber = pn;
                        });
                      },
                      onInputValidated: (bool value) {
                        print(value);
                      },
                      selectorConfig: SelectorConfig(
                        selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                      ),
                      ignoreBlank: false,
                      autoValidateMode: AutovalidateMode.disabled,
                      selectorTextStyle: TextStyle(color: Colors.black),
                      initialValue: number,
                      textFieldController: _mobileNumberController,
                      formatInput: false,
                      // keyboardType: TextInputType.number,
                      keyboardType: TextInputType.numberWithOptions(
                          signed: true, decimal: true),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _body() {
    if (_isLoading) {
      return Aesthetic.displayCircle();
    } else if (_showReload) {
      return Aesthetic.refreshButton(context: context, route: AddMobilePage());
    } else {
      return _displayMobile();
    }
  }

  String verificationId = '';
  String phone = '';
  bool codesent = false;
  addmobile() async {
    phone = '+23057775794'; //from setstate
    // FirebaseAuth auth = FirebaseAuth.instance;
    print('existing');
    FirebaseAuthenticate().getfirebaseuid();
    FirebaseAuthenticate().getfirebasefcmtoken();
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance
            .signInWithCredential(credential); //auto retrive otp
        print('auto signed in');
      },
      verificationFailed: (FirebaseAuthException e) {
        print(e);
      },
      codeSent: (String verificationid, int? resendToken) {
        //when receive sms code
        setState(() {
          codesent = true;
          verificationId = verificationid;
        });
      },
      codeAutoRetrievalTimeout: (String verificationid) {
        setState(() {
          verificationId = verificationid;
          print(verificationId);
        });
      },
      timeout: Duration(seconds: 60),
    );
    print('new');
    FirebaseAuthenticate().getfirebaseuid();
    FirebaseAuthenticate().getfirebasefcmtoken();
  }

  verifyPin(String smsCode) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: smsCode);
    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      print('lobin success');
    } catch (e) {
      print(e);
    }
  }

  // otptesting() {
  //   FlutterOtp otp = FlutterOtp();
  //   String countryCode =
  //       "+230"; // give your country code if not it will take +1 as default
  //   String phoneNumber = "57775794"; //enter your 10 digit number
  //   int minNumber = 1000;
  //   int maxNumber = 6000;

  //   otp.sendOtp(
  //     phoneNumber,
  //     'OTP is : pass the generated otp here ',
  //     minNumber,
  //     maxNumber,
  //     countryCode,
  //   );
  // }

  @override
  void initState() {
    super.initState();
    initPlatformState().whenComplete(() => setState(() {
          _mobileName.text = _deviceData;
          _isLoading = false;
        }));
    //otptesting();
    addmobile();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        top: true,
        bottom: true,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(
                Icons.clear_outlined,
                color: Colors.red,
              ),
              onPressed: () {
                DialogBox.showDiscardDialog(
                    context: context,
                    title: 'Discard Change(s)',
                    body: 'Are you sure you want to discard changes made?',
                    buttonText: 'Discard',
                    route: MobilePage());
              },
            ),
            automaticallyImplyLeading: true,
            backgroundColor: Colors.blue[100],
            title: Text(
              'New Mobile',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            centerTitle: true,
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.check_outlined,
                  color: Colors.green,
                ),
                onPressed: () {
                  setState(() {
                    _mobileName.text.isEmpty
                        ? _validateName = true
                        : _validateName = false;
                    _mobileDescription.text.isEmpty
                        ? _validateDescription = true
                        : _validateDescription = false;
                    _numwithoutcode.length == 0
                        ? _validateNumber = true
                        : _validateNumber = false;
                  });
                  _showAcceptDialog();
                },
              ),
            ],
          ),
          body: _body(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _mobileNumberController.dispose();
    _mobileName.dispose();
    _mobileDescription.dispose();
    super.dispose();
  }
}
