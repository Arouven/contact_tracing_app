import 'dart:async';
import 'package:contact_tracing/main.dart';
import 'package:contact_tracing/services/apiMobile.dart';
import 'package:contact_tracing/services/auth.dart';
import 'package:contact_tracing/services/databaseServices.dart';
import 'package:contact_tracing/services/globals.dart';
import 'package:contact_tracing/widgets/commonWidgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:contact_tracing/models/mobile.dart';
import 'package:contact_tracing/pages/Mobile/addMobile.dart';
import 'package:contact_tracing/pages/Mobile/updateMobile.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import '../../widgets/drawer.dart';

class MobilePage extends StatefulWidget {
  static const String route = '/mobiles';

  @override
  _MobilePageState createState() {
    print("in mobiles");
    return _MobilePageState();
  }
}

class _MobilePageState extends State<MobilePage> {
  //declaring variables

  bool _isLoading = true;
  //bool _showReload = false;
  //late int _selectedRadioTile;
  late String _mymobileNumber = '';
  late String _mobileNumberToSetActive = '';
  //bool _findSelected = false;
  var _mobiles = [];

  /// display dialog
  /// if the user is sure he/she want to edit [mobile]
  Future<void> _showEditDialog(Mobile mobile) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Modify Mobile',
            style: TextStyle(
              color: Colors.orange,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                new Row(
                  children: [
                    Expanded(
                      child: Text(
                          'Are you sure you want to make changes to "${mobile.mobileName}" mobile?'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: Theme.of(context).textButtonTheme.style,
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: Theme.of(context).textButtonTheme.style,
              child: const Text('Modify'),
              onPressed: () {
                // open a UpdateMobilePage with parameter [mobile]
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                        UpdateMobilePage(mobile: mobile),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _otpPage() {
    return Container(
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
            onCompleted: (smsCode) {
              _verifyPin(smsCode: smsCode);
            },
          ),
        ],
      ),
    );
  }

  bool _codeSent = false;
  var _verificationId = '';
  _verifyPhone() async {
    final email = await GlobalVariables.getEmail();

    if ((email != null)) {
      print('existing');
      print(_mobileNumberToSetActive);
      // FirebaseAuthenticate().getfirebaseuid();
      //FirebaseAuthenticate().getfirebasefcmtoken();

      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: _mobileNumberToSetActive,
        verificationCompleted: (PhoneAuthCredential credential) async {
          print('verificationCompleted');
          await FirebaseAuth.instance.signInWithCredential(
            credential,
          ); //auto retrive otp
          print('auto signed in');
          print('new');
          FirebaseAuthenticate().getfirebaseuid();
          FirebaseAuthenticate().getfirebasefcmtoken();
          await _updateMysql();
          await GlobalVariables.setMobileNumber(
            mobileNumber: _mobileNumberToSetActive,
          );
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
          print('codeautoretrievaltimeout');
          //  if (_signedin == true) {
          //} else {
          setState(() {
            _verificationId = verificationid;
            print('verificationid: ' + _verificationId);
            _isLoading = false;
          });
          //}
        },
        timeout: Duration(seconds: 120),
      );
    }
  }

  _verifyPin({required String smsCode}) async {
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
      await _updateMysql();
      await GlobalVariables.setMobileNumber(
          mobileNumber: _mobileNumberToSetActive);
      // setState(() {
      // _signedin = true;
      // });
    } on FirebaseAuthException catch (e) {
      // setState(() {
      //   _signedin = false;
      // });
      print('verifyPin exception');
      print(e);
      DialogBox.showErrorDialog(
        context: context,
        body: e.message.toString(),
      );
    }
  }

  Future _updateMysql() async {
    final mobileNumber = await GlobalVariables.getMobileNumber();
    final fcmtoken = await FirebaseAuthenticate().getfirebasefcmtoken();
    if (fcmtoken != null) {
      final response = await DatabaseMySQLServices.updateMobilefmcToken(
        mobileNumber: mobileNumber,
        fcmtoken: fcmtoken,
      );

      if (response['msg'] == 'success') {
        await GlobalVariables.setMobileNumber(
          mobileNumber: _mobileNumberToSetActive,
        );
        print('start services from updatemysql');
        await startServices();
        setState(() {
          _mymobileNumber = _mobileNumberToSetActive;
          _isLoading = false;
        });
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => MobilePage(),
        ));
      } else {
        DialogBox.showErrorDialog(
          context: context,
          title: response['msg'],
          body: response['error'],
        );
      }
      print('updated successfully');
    }
  }

  /// display add mobile dialog
  Future<void> _showSetActiveDialog(Mobile mobile) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Set Mobile Active?',
            style: TextStyle(
              color: Colors.orange,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                new Row(
                  children: [
                    Expanded(
                      child: Text(
                          'Are you sure you want to set this mobile as active?'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: Theme.of(context).textButtonTheme.style,
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: Theme.of(context).textButtonTheme.style,
              child: const Text('Yes'),
              onPressed: () async {
                setState(() {
                  _mobileNumberToSetActive = mobile.mobileNumber;
                });
                Navigator.of(context).pop();
                _verifyPhone();
              },
            ),
          ],
        );
      },
    );
  }

  /// take [mobiles] as List<Mobile>
  /// build the radio buttons with text
  /// return the list<Widget>
  Widget _buildMobiles() {
    print('building mobiles');
    return Scrollbar(
      child: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(Duration(seconds: 2));
          List<Mobile> mobiles = await ApiMobile.getMobiles();
          setState(() {
            print('pull to refresh');
            _mobiles = mobiles;
            _mobiles.add(new Mobile(
              mobileNumber: '',
              mobileName: '',
              email: '',
              fcmtoken: '',
            ));
            _isLoading = false;
          });
        },
        child: ListView.builder(
          itemCount: _mobiles.length,
          itemBuilder: (BuildContext context, int index) {
            return (_mobiles[index].mobileNumber == '')
                ? ListTile()
                : ListTile(
                    title: Text(
                      _mobiles[index].mobileNumber,
                      style: (_mymobileNumber == _mobiles[index].mobileNumber)
                          ? TextStyle(fontWeight: FontWeight.bold)
                          : null,
                    ),
                    subtitle: (_mymobileNumber == _mobiles[index].mobileNumber)
                        ? Text(
                            'Active',
                            style: TextStyle(
                              color: Colors.green,
                            ),
                          )
                        : null,
                    trailing: PopupMenuButton(
                        itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                              PopupMenuItem(
                                child: TextButton(
                                  style:
                                      Theme.of(context).textButtonTheme.style,
                                  child: const Text(
                                    'Set Active',
                                    // style: TextStyle(color: Colors.black),
                                  ),
                                  onPressed: () async {
                                    print('set active');
                                    await _showSetActiveDialog(_mobiles[index]);
                                    print(_mobiles[index].fcmtoken);
                                  },
                                ),
                              ),
                              PopupMenuItem(
                                child: TextButton(
                                  style:
                                      Theme.of(context).textButtonTheme.style,
                                  child: const Text(
                                    'Edit Mobile',
                                    // style: TextStyle(color: Colors.black),
                                  ),
                                  onPressed: () async {
                                    print('editmobile');
                                    await _showEditDialog(_mobiles[index]);
                                    print(_mobiles[index].fcmtoken);
                                  },
                                ),
                              )
                            ]),
                  );
          },
        ),
      ),
    );
  }

  /// return the body of the page
  Widget _body() {
    if (_isLoading == true) {
      return Center(child: CircularProgressIndicator());
    } else {
      return Container(
        padding: EdgeInsets.all(10.0),
        child: Center(
          child: _codeSent ? _otpPage() : _buildMobiles(),
        ),
      );
    }
  }

  /// display the add button
  /// if is not loading and has not encounter error
  Widget? _floatingActionButton() {
    if (_isLoading) {
      return null;
    } else {
      return FloatingActionButton(
          child: Icon(
            Icons.add,
          ),
          onPressed: () {
            setState(() {
              _isLoading = true;
            });
            Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => AddMobilePage(),
            ));
          });
    }
  }

  Future _getMobileNumber() async {
    final mobileNumber = await GlobalVariables.getMobileNumber();
    return (mobileNumber != null) ? mobileNumber : '';
  }

  @override
  void initState() {
    _getMobileNumber().then((value) {
      setState(() {
        _mymobileNumber = value;
      });
      if (_mymobileNumber != '') {
        startServices().whenComplete(() {
          print("initState()");
        });
      }

      ApiMobile.getMobiles().then((mobileList) {
        setState(() {
          _mobiles = mobileList;
          _mobiles.add(new Mobile(
            mobileNumber: '',
            mobileName: '',
            email: '',
            fcmtoken: '',
          ));
          _isLoading = false;
        });
        if (mobileList.isEmpty) {
          DialogBox.showErrorDialog(
            context: context,
            title: 'No Mobile!',
            body: 'Click on the plus sign below to add your mobile',
          );
        }
      });
    });

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
            title: Text('Mobiles'),
            centerTitle: true,
            // backgroundColor: Colors.blue,
          ),
          drawer: buildDrawer(context, MobilePage.route),
          body: _body(),
          floatingActionButton: _floatingActionButton(),
        ),
      ),
    );
  }
}
