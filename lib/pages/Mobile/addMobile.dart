import 'dart:io';
import 'package:contact_tracing/pages/Mobile/mobiles.dart';
import 'package:contact_tracing/providers/thememanager.dart';
import 'package:contact_tracing/services/auth.dart';
import 'package:contact_tracing/services/databaseServices.dart';
import 'package:contact_tracing/services/globals.dart';
import 'package:contact_tracing/widgets/commonWidgets.dart';
import 'package:contact_tracing/widgets/drawer.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:provider/provider.dart';

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
  bool _invalidMobileName = false;
  bool _invalidPhoneNumber = false;
  String _numwithoutcode = '';
  String initialCountry = 'MU';
  PhoneNumber number = PhoneNumber(isoCode: 'MU');
  String _mobileNumber = '';

  String _verificationId = '';
  String _phoneNumber = '';
  bool _codeSent = false;

  TextEditingController _mobileNumberController = TextEditingController();
  TextEditingController _mobileName = TextEditingController();

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

  _updateMysql() async {
    print('add button pressed');
    setState(() {
      _isLoading = true;
    });
    // Navigator.of(context).pop();

    //  String? firebaseuid = FirebaseAuthenticate().getfirebaseuid();
    String? fcmtoken = await FirebaseAuthenticate().getfirebasefcmtoken();
    final email = await GlobalVariables.getEmail();

    final data = await DatabaseMySQLServices.addMobile(
      mobileName: _mobileName.text.trim(),
      email: email!,
      mobileNumber: _mobileNumber.trim(),
      fcmtoken: fcmtoken!,
    );
    if (data != 'Error') {
      print(data);
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => MobilePage(),
        ),
        (e) => false,
      );
    } else {
      setState(() {
        _isLoading = false;
        _showReload = true;
      });
    }
  }

  List<Widget> _fields() {
    return <Widget>[
      new Container(
          child: new Row(
        children: <Widget>[
          Expanded(
            child: new TextField(
              controller: _mobileName,
              decoration: new InputDecoration(
                labelText: 'Mobile Name',
                errorText: _invalidMobileName ? 'Name Can\'t Be Empty' : null,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.info),
            // color: Colors.black,
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
        child: InternationalPhoneNumberInput(
          inputDecoration: new InputDecoration(
            labelText: 'Mobile Number',
            errorText: _invalidPhoneNumber ? 'Number Can\'t Be Empty' : null,
          ),
          onInputChanged: (PhoneNumber number) {
            String? pn = number.phoneNumber;

            _numwithoutcode =
                (pn!.substring(number.dialCode!.length, pn.length));
            print(_numwithoutcode);
            setState(() {
              _phoneNumber = number.phoneNumber!;
              _numwithoutcode.length == 0
                  ? _invalidPhoneNumber = true
                  : _invalidPhoneNumber = false;
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
          // selectorTextStyle: TextStyle(color: Colors.black),
          initialValue: number,
          textFieldController: _mobileNumberController,
          formatInput: false,
          keyboardType: TextInputType.number,
        ),
      ),
      new Container(
        height: 40,
      ),
      new Container(
        width: 100,
        child: new ElevatedButton(
          style: Theme.of(context).elevatedButtonTheme.style,
          child: new Text('Next'),
          onPressed: () async {
            await _verifyPhone();
          },
        ),
      ),
    ];
  }

  Widget _displayMobile() {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Center(
        child: _codeSent
            ? Container(
                height: 80,
                child: new Column(
                  children: <Widget>[
                    Text('OTP'),
                    OTPTextField(
                      otpFieldStyle:
                          Provider.of<ThemeProvider>(context).themeMode ==
                                  ThemeMode.dark
                              ? OtpFieldStyle(
                                  backgroundColor: Colors.transparent,
                                  borderColor: Colors.grey,
                                  focusBorderColor: Colors.white,
                                  disabledBorderColor: Colors.white54,
                                  enabledBorderColor: Colors.white,
                                  errorBorderColor: Colors.red,
                                )
                              : OtpFieldStyle(
                                  backgroundColor: Colors.transparent,
                                  borderColor: Colors.black26,
                                  focusBorderColor: Colors.blue,
                                  disabledBorderColor: Colors.grey,
                                  enabledBorderColor: Colors.black26,
                                  errorBorderColor: Colors.red,
                                ),
                      length: 6,
                      width: MediaQuery.of(context).size.width,
                      fieldWidth: 30,
                      style: TextStyle(fontSize: 20),
                      textFieldAlignment: MainAxisAlignment.spaceAround,
                      fieldStyle: FieldStyle.underline,
                      onCompleted: (pin) {
                        _verifyPin(pin);
                      },
                    ),
                  ],
                ),
              )
            : ListView(
                children: <Widget>[
                  new Container(
                    child: new Column(
                      children: _fields(),
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

  //bool _signedin = false;
  _verifyPhone() async {
    setState(() {
      _isLoading = true;
      _mobileName.text.isEmpty
          ? _invalidMobileName = true
          : _invalidMobileName = false;
      _numwithoutcode.length == 0
          ? _invalidPhoneNumber = true
          : _invalidPhoneNumber = false;
    });
    print(_invalidMobileName);
    print(_invalidPhoneNumber);

    final email = await GlobalVariables.getEmail();

    if ((_invalidMobileName == false) &&
        (_invalidPhoneNumber == false) &&
        (email != null)) {
      print('existing');
      print(_phoneNumber);
      // FirebaseAuthenticate().getfirebaseuid();
      //FirebaseAuthenticate().getfirebasefcmtoken();

      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: _phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          print('verificationCompleted');
          await FirebaseAuth.instance.signInWithCredential(
            credential,
          ); //auto retrive otp
          print('auto signed in');
          print('new');
          FirebaseAuthenticate().getfirebaseuid();
          FirebaseAuthenticate().getfirebasefcmtoken();

          await GlobalVariables.setMobileNumber(
            mobileNumber: _mobileNumber,
          );
          await _updateMysql();
          setState(() {
            //   _signedin = true;
            _isLoading = false;
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          print('verificationFailed');
          print(e);
          setState(() {
            _isLoading = false;
          });
          DialogBox.showErrorDialog(
            context: context,
            body: e.message.toString(),
          );
        },
        codeSent: (String verificationid, int? resendToken) {
          print('codesent');
          setState(() {
            _codeSent = true;
            _verificationId = verificationid;
            print('verificationid: ' + _verificationId);
            _isLoading = false;
          });
        },
        codeAutoRetrievalTimeout: (String verificationid) {
          _codeSent = false;
          print('codeautoretrievaltimeout');
          _verificationId = verificationid;
          print('verificationid: ' + _verificationId);
          _isLoading = false;
        },
        timeout: Duration(seconds: 120),
      );
    }
  }

  _verifyPin(String smsCode) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: _verificationId,
      smsCode: smsCode,
    );
    print('verificationid: ' + _verificationId);
    print('smsCode: ' + smsCode);
    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      print('lobin success');
      print('new');
      FirebaseAuthenticate().getfirebaseuid();
      await FirebaseAuthenticate().getfirebasefcmtoken();

      await GlobalVariables.setMobileNumber(
          mobileNumber: _mobileNumber); //save in prefs
      await _updateMysql();
    } on FirebaseAuthException catch (e) {
      print('verifyPin exception');
      print(e);
      DialogBox.showErrorDialog(
        context: context,
        body: e.message.toString(),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    initPlatformState().whenComplete(() => setState(() {
          _verificationId = '';
          _phoneNumber = '';
          _codeSent = false;
          _mobileName.text = _deviceData;
          _isLoading = false;
        }));
    //addmobile();
    //verifyPin('661230');
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
            leading: BackButton(
              onPressed: () {
                DialogBox.showDiscardDialog(
                    context: context,
                    title: 'Discard Change(s)',
                    body: 'Are you sure you want to discard changes made?',
                    buttonText: 'Discard',
                    route: MobilePage());
              },
            ),
            title: Text('New Mobile'),
            centerTitle: true,
            // backgroundColor: Colors.blue,
          ),
          drawer: buildDrawer(context, MobilePage.route),
          body: _body(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _mobileNumberController.dispose();
    _mobileName.dispose();
    super.dispose();
  }
}
