import 'dart:io';
import 'package:contact_tracing/models/mobile.dart';
import 'package:contact_tracing/services/auth.dart';
import 'package:contact_tracing/services/databaseServices.dart';
import 'package:contact_tracing/widgets/drawer.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'mobiles.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import '../../widgets/commonWidgets.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';

class UpdateMobilePage extends StatefulWidget {
  final Mobile mobile;
  static const String route = '/updateMobile';
  const UpdateMobilePage({
    Key? key,
    required this.mobile,
  }) : super(key: key);
  @override
  _UpdateMobilePageState createState() {
    print("in updateMobile");
    return _UpdateMobilePageState();
  }
}

class _UpdateMobilePageState extends State<UpdateMobilePage> {
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
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');

    final data = await DatabaseServices.updateMobile(
      mobileName: _mobileName.text.toString(),
      email: email!,
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
          selectorTextStyle: TextStyle(color: Colors.black),
          initialValue: number,
          textFieldController: _mobileNumberController,
          formatInput: false,
          keyboardType: TextInputType.number,
          // keyboardType: TextInputType.numberWithOptions(
          //     signed: true, decimal: true),
        ),
      ),
      new Container(
        height: 40,
      ),
      new Container(
        width: 100,
        child: new ElevatedButton(
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
      return Aesthetic.refreshButton(
          context: context,
          route: UpdateMobilePage(
            mobile: widget.mobile,
          ));
    } else {
      return _displayMobile();
    }
  }

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
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');

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
          await FirebaseAuth.instance
              .signInWithCredential(credential); //auto retrive otp
          print('auto signed in');
          print('new');
          FirebaseAuthenticate().getfirebaseuid();
          FirebaseAuthenticate().getfirebasefcmtoken();
          await _updateMysql();
        },
        verificationFailed: (FirebaseAuthException e) {
          print('verificationFailed');
          print(e);
          DialogBox.showErrorDialog(
            context: context,
            body: e.message.toString(),
          );
        },
        codeSent: (String verificationid, int? resendToken) {
          //when receive sms code
          setState(() {
            _codeSent = true;
            _verificationId = verificationid;
            print('verificationid: ' + _verificationId);
          });
        },
        codeAutoRetrievalTimeout: (String verificationid) {
          setState(() {
            _verificationId = verificationid;
            print('verificationid: ' + _verificationId);
          });
        },
        timeout: Duration(seconds: 120),
      );
    }
    setState(() {
      _isLoading = false;
    });
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
      FirebaseAuthenticate().getfirebasefcmtoken();
      await _updateMysql();
    } on FirebaseAuthException catch (e) {
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
          _mobileName.text = _deviceData;
          _isLoading = false;
        }));
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
            title: Text('Update Mobile'),
            centerTitle: true,
            backgroundColor: Colors.blue,
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
// //import 'dart:convert';
// import 'dart:io';
// import 'package:contact_tracing/services/auth.dart';
// import 'package:contact_tracing/services/databaseServices.dart';
// //import 'package:contact_tracing/services/globals.dart';
// import 'package:device_info/device_info.dart';
// import 'package:intl_phone_number_input/intl_phone_number_input.dart';
// //import '../../classes/globals.dart';
// import 'package:contact_tracing/models/mobile.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// //import 'package:http/http.dart' as http;
// import 'mobiles.dart';
// import 'dart:async';
// import 'package:flutter/services.dart';
// import '../../widgets/commonWidgets.dart';

// class UpdateMobilePage extends StatefulWidget {
//   final Mobile mobile;
//   static const String route = '/updateMobile';
//   const UpdateMobilePage({
//     Key? key,
//     required this.mobile,
//   }) : super(key: key);
//   @override
//   _UpdateMobilePageState createState() {
//     print("in updateMobile");
//     return _UpdateMobilePageState();
//   }
// }

// class _UpdateMobilePageState extends State<UpdateMobilePage> {
//   static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
//   String _deviceData = "";
//   bool _isLoading = true;
//   bool _showReload = false;
//   bool _invalidName = false;
//   bool _invalidNumber = false;
//   String _numwithoutcode = '';
//   String initialCountry = 'MU';
//   PhoneNumber number = PhoneNumber(isoCode: 'MU');
//   String _mobileNumber = '';

//   TextEditingController _mobileNumberController = TextEditingController();
//   TextEditingController _mobileName = TextEditingController();

//   Future<void> initPlatformState() async {
//     String deviceData = "";
//     try {
//       if (Platform.isAndroid) {
//         deviceData = (await deviceInfoPlugin.androidInfo).model.toString();
//       } else if (Platform.isIOS) {
//         deviceData = (await deviceInfoPlugin.iosInfo).model.toString();
//       }
//     } on PlatformException {
//       deviceData = 'Error:';
//     }
//     if (!mounted) return;
//     setState(() {
//       _deviceData = deviceData;
//     });
//   }

//   _updateButtonPressed() async {
//     Navigator.of(context).pop();
//     setState(() {
//       _isLoading = true;
//     });
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     final email = prefs.getString('email');
//     String? fcmtoken = await FirebaseAuthenticate().getfirebasefcmtoken();
//     var data;
//     try {
//       data = await DatabaseServices.updateMobile(
//         mobileNumber: widget.mobile.mobileNumber,
//         mobileName: _mobileName.text,
//         email: email!,
//         fcmtoken: fcmtoken!,
//       );
//       if (data != 'Error') {
//         Navigator.of(context).pushAndRemoveUntil(
//           MaterialPageRoute(
//             builder: (context) => MobilePage(),
//           ),
//           (e) => false,
//         );
//       } else {
//         setState(() {
//           _isLoading = false;
//           _showReload = true;
//         });
//       }
//     } catch (e) {
//       print(e.toString());
//       setState(() {
//         _isLoading = false;
//         _showReload = true;
//       });
//     }
//     print(data);
//   }

//   Future<void> _showAcceptDialog() async {
//     if ((_invalidName == false) && (_invalidNumber == false)) {
//       return showDialog<void>(
//         context: context,
//         barrierDismissible: false, // user must tap button!
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: const Text(
//               'Save Change(s)',
//               style: TextStyle(color: Colors.orange),
//             ),
//             content: SingleChildScrollView(
//               child: ListBody(
//                 children: <Widget>[
//                   new Row(
//                     children: [
//                       Expanded(
//                         child: Text(
//                             'Are you sure you want to save change(s) made?'),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             actions: <Widget>[
//               TextButton(
//                 child: const Text('Cancel'),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//               ),
//               TextButton(
//                 child: const Text('Accept'),
//                 onPressed: () async {
//                   await _updateButtonPressed();
//                 },
//               ),
//             ],
//           );
//         },
//       );
//     } else {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//     return null;
//   }

//   Widget _displayMobile() {
//     return Container(
//       padding: EdgeInsets.all(10.0),
//       child: Center(
//         child: ListView(
//           children: <Widget>[
//             new Container(
//               child: new Column(
//                 children: <Widget>[
//                   new Container(
//                     child: new Row(
//                       children: <Widget>[
//                         Expanded(
//                           child: new TextField(
//                             controller: _mobileName,
//                             decoration: new InputDecoration(
//                               labelText: 'Mobile Name',
//                               errorText:
//                                   _invalidName ? 'Name Can\'t Be Empty' : null,
//                             ),
//                           ),
//                         ),
//                         IconButton(
//                           icon: Icon(Icons.info),
//                           color: Colors.black,
//                           iconSize: 30.0,
//                           alignment: Alignment.centerRight,
//                           onPressed: () {
//                             setState(() {
//                               _mobileName.text = _deviceData;
//                             });
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                   new Container(
//                     child: InternationalPhoneNumberInput(
//                       inputDecoration: new InputDecoration(
//                         labelText: 'Mobile Number',
//                         errorText:
//                             _invalidNumber ? 'Number Can\'t Be Empty' : null,
//                       ),
//                       onInputChanged: (PhoneNumber number) {
//                         String? pn = number.phoneNumber;
//                         _numwithoutcode =
//                             (pn!.substring(number.dialCode!.length, pn.length));
//                         //print('hhhhhhhhhhhhhhhhhhhhhhhhh');
//                         print(_numwithoutcode);
//                         print(number);
//                         print(number.phoneNumber);
//                         setState(() {
//                           _numwithoutcode.length == 0
//                               ? _invalidNumber = true
//                               : _invalidNumber = false;
//                           _mobileNumber = pn;
//                         });
//                       },
//                       onInputValidated: (bool value) {
//                         print(value);
//                       },
//                       selectorConfig: SelectorConfig(
//                         selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
//                       ),
//                       ignoreBlank: false,
//                       autoValidateMode: AutovalidateMode.disabled,
//                       selectorTextStyle: TextStyle(color: Colors.black),
//                       initialValue: number,
//                       textFieldController: _mobileNumberController,
//                       formatInput: false,
//                       keyboardType: TextInputType.numberWithOptions(
//                           signed: true, decimal: true),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _body() {
//     if (_isLoading) {
//       return Aesthetic.displayCircle();
//     } else if (_showReload) {
//       return Aesthetic.refreshButton(
//           route: UpdateMobilePage(mobile: widget.mobile));
//     } else {
//       return _displayMobile();
//     }
//   }

//   void getPhoneNumber(String phoneNumber) async {
//     PhoneNumber number =
//         await PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumber, 'MU');

//     setState(() {
//       this.number = number;
//     });
//     //print(number);
//   }

//   @override
//   void initState() {
//     super.initState();
//     initPlatformState().whenComplete(() => setState(() {
//           _mobileName.text = widget.mobile.mobileName;
//           _mobileNumber = widget.mobile.mobileNumber;

//           getPhoneNumber(_mobileNumber);
//           //print(number);
//           _isLoading = false;
//         }));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.white,
//       child: SafeArea(
//         top: true,
//         bottom: true,
//         child: Scaffold(
//           appBar: AppBar(
//             leading: IconButton(
//               icon: Icon(
//                 Icons.clear_outlined,
//                 color: Colors.red,
//               ),
//               onPressed: () {
//                 DialogBox.showDiscardDialog(
//                     context: context, route: MobilePage());
//               },
//             ),
//             automaticallyImplyLeading: true,
//             backgroundColor: Colors.blue[100],
//             title: Text(
//               'Update Mobile',
//               style: TextStyle(
//                 color: Colors.black,
//               ),
//             ),
//             centerTitle: true,
//             actions: <Widget>[
//               IconButton(
//                 icon: Icon(
//                   Icons.check_outlined,
//                   color: Colors.green,
//                 ),
//                 onPressed: () {
//                   _showAcceptDialog();
//                 },
//               ),
//             ],
//           ),
//           body: _body(),
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _mobileName.dispose();
//     _mobileNumberController.dispose();
//     super.dispose();
//   }
// }
