import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:contact_tracing/main.dart';
import 'package:contact_tracing/providers/notificationbadgemanager.dart';
import 'package:contact_tracing/providers/thememanager.dart';
import 'package:contact_tracing/services/apiMobile.dart';
import 'package:contact_tracing/services/auth.dart';
import 'package:contact_tracing/services/badgeservices.dart';
import 'package:contact_tracing/services/databaseServices.dart';
import 'package:contact_tracing/services/globals.dart';
import 'package:contact_tracing/widgets/commonWidgets.dart';
import 'package:contact_tracing/widgets/drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:contact_tracing/models/mobile.dart';
import 'package:contact_tracing/pages/Mobile/addMobile.dart';
import 'package:contact_tracing/pages/Mobile/updateMobile.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:provider/provider.dart';

Future checkMobileNumber({required var context}) async {
  var mn = await GlobalVariables.getMobileNumber();
  if (mn == null) {
    await DialogBox.showErrorDialog(
      context: context,
      title: 'Mobile Not Active',
      body:
          'Please set an active mobile to help the application to keep track of your locations.',
    );
  }
}

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
  late bool _service = false;
  bool _isLoading = true;
  //bool _showReload = false;
  //late int _selectedRadioTile;
  late String _mymobileNumber = '';
  late String _mobileNumberToSetActive = '';
  //bool _findSelected = false;
  var _mobiles = [];
  bool _codeSent = false;
  var _verificationId = '';

  late var _subscription;
  late var _firebaseListener = null;
  bool _internetConnection = true;

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
            otpFieldStyle:
                Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark
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
            onCompleted: (smsCode) {
              _verifyPin(smsCode: smsCode.toString());
            },
          ),
        ],
      ),
    );
  }

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

          await GlobalVariables.setMobileNumber(
            mobileNumber: _mobileNumberToSetActive,
          );
          await _updateMysql();

          try {
            setState(() {
              //   _signedin = true;
              _isLoading = false;
            });
          } catch (e) {
            print(e);
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          print('verificationFailed');
          print(e);
          try {
            setState(() {
              _isLoading = false;
            });
          } catch (e) {
            print(e);
          }
          DialogBox.showErrorDialog(
            context: context,
            body: e.message.toString(),
          );
        },
        codeSent: (String verificationid, int? resendToken) {
          print('codesent');
          try {
            setState(() {
              _codeSent = true;
              _verificationId = verificationid;
              print('verificationid: ' + _verificationId);
              _isLoading = false;
            });
          } catch (e) {
            print(e);
          }
        },
        codeAutoRetrievalTimeout: (String verificationid) {
          print('codeautoretrievaltimeout');
          //  if (_signedin == true) {
          //} else {
          try {
            setState(() {
              _codeSent = false;
              _verificationId = verificationid;
              print('verificationid: ' + _verificationId);
              _isLoading = false;
            });
          } catch (e) {
            print(e);
          }
          //}
        },
        timeout: Duration(seconds: 120),
      );
    }
  }

  _verifyPin({required String smsCode}) async {
    try {
      setState(() {
        _isLoading = true;
      });
    } catch (e) {
      print(e);
    }
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
          mobileNumber: _mobileNumberToSetActive);
      await _updateMysql();

      setState(() {
        _isLoading = false;
      });
    } on FirebaseAuthException catch (e) {
      try {
        setState(() {
          _isLoading = false;
        });
      } catch (e) {
        print(e);
      }
      print('verifyPin exception');
      print(e);
      await DialogBox.showErrorDialog(
        context: context,
        body: e.message.toString(),
      );
      try {
        setState(() {
          _codeSent = false;
        });
      } catch (e) {
        print(e);
      }
    }
  }

  Future _updateMysql() async {
    final String mobileNumber = await GlobalVariables.getMobileNumber();
    final fcmtoken = await FirebaseAuthenticate().getfirebasefcmtoken();
    print(mobileNumber.toString());
    print(fcmtoken.toString());
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
        await generatePath();
        await startServices();

        // Provider.of<NotificationBadgeProvider>(context, listen: false);
        _startListening();
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
                  _isLoading = true;
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

  // void actionPopUpItemSelected(String value, String name) {
  //   _scaffoldkey.currentState.hideCurrentSnackBar();
  //   String message;
  //   if (value == 'edit') {
  //       message = 'You selected edit for $name';
  //   } else if (value == 'delete') {
  //       message = 'You selected delete for $name';
  //   } else {
  //       message = 'Not implemented';
  //   }
  //   final snackBar = SnackBar(content: Text(message));
  //   _scaffoldkey.currentState.showSnackBar(snackBar);
  // }
  /// take [mobiles] as List<Mobile>
  /// build the radio buttons with text
  /// return the list<Widget>
  Widget _buildMobiles() {
    print('building mobiles');
    return Scrollbar(
      child: RefreshIndicator(
        onRefresh: () async {
          List<Mobile> mobiles = await ApiMobile.getMobiles();
          await Future.delayed(
              Duration(seconds: 2)); //to allow circular loading
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
                    trailing:
                        //              PopupMenuButton(
                        //  itemBuilder: (context) {
                        //         return [
                        //           PopupMenuItem(
                        //             value: 'edit',
                        //             child: Text('Edit'),
                        //           ),
                        //           PopupMenuItem(
                        //             value: 'delete',
                        //             child: Text('Delete'),
                        //           )
                        //         ];
                        //       },
                        //       onSelected: (String value) => actionPopUpItemSelected(value, name),

                        // PopupMenuButton(
                        //     itemBuilder: (BuildContext context) =>
                        //         <PopupMenuEntry>[
                        //           PopupMenuItem(
                        //             child: TextButton(
                        //               style: Theme.of(context)
                        //                   .textButtonTheme
                        //                   .style,
                        //               child: const Text(
                        //                 'Set Active',
                        //                 // style: TextStyle(color: Colors.black),
                        //               ),
                        //               onPressed: () async {
                        //                 print('set active');
                        //                 await _showSetActiveDialog(
                        //                     _mobiles[index]);
                        //                 print(_mobiles[index].fcmtoken);
                        //                 Navigator.of(context).pop();
                        //               },
                        //             ),
                        //           ),
                        //           PopupMenuItem(
                        //             child: TextButton(
                        //               style: Theme.of(context)
                        //                   .textButtonTheme
                        //                   .style,
                        //               child: const Text(
                        //                 'Edit Mobile',
                        //                 // style: TextStyle(color: Colors.black),
                        //               ),
                        //               onPressed: () async {
                        //                 print('editmobile');
                        //                 await _showEditDialog(_mobiles[index]);
                        //                 print(_mobiles[index].fcmtoken);
                        //               },
                        //             ),
                        //           )
                        //         ]),

                        PopupMenuButton(
                      itemBuilder: (BuildContext context) {
                        return <PopupMenuEntry>[
                          PopupMenuItem(
                            child: Text(
                              'Set Active',
                              // style: TextStyle(color: Colors.black),
                            ),
                            onTap: () async {
                              print('set active');
                              Future.delayed(Duration.zero).then((value) async {
                                await _showSetActiveDialog(_mobiles[index]);
                              });

                              // await _showSetActiveDialog(_mobiles[index]);
                              print(_mobiles[index].fcmtoken);
                              // Navigator.of(context).pop();
                            },
                          ),
                          PopupMenuItem(
                            child: const Text(
                              'Edit Mobile',
                              // style: TextStyle(color: Colors.black),
                            ),
                            onTap: () async {
                              print('editmobile');
                              Future.delayed(Duration.zero).then((value) async {
                                await _showEditDialog(_mobiles[index]);
                              });
                              print(_mobiles[index].fcmtoken);
                            },
                          ),
                        ];
                      },
                      // onSelected: (Mobile mobile) async {
                      //  // print(value);
                      //      await _showSetActiveDialog(mobile);
                      // },
                    ),
                  );
          },
        ),
      ),
    );
  }

  /// return the body of the page
  Widget _body() {
    if (_internetConnection == false) {
      return Aesthetic.displayNoConnection();
    } else {
      if (_isLoading == true) {
        return Aesthetic
            .displayCircle(); //Center(child: CircularProgressIndicator());
      } else {
        if (_codeSent) {
          return Container(
            padding: EdgeInsets.all(10.0),
            child: Center(child: _otpPage()),
          );
        } else {
          return Container(
            child: _buildMobiles(),
          );
        }
      }
    }
  }

  /// display the add button
  /// if is not loading and has not encounter error
  Widget? _floatingActionButton() {
    if (_isLoading || _codeSent) {
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
    try {
      final mobileNumber = await GlobalVariables.getMobileNumber();
      if (mobileNumber != null) {
        setState(() {
          _mymobileNumber = mobileNumber;
        });
      } else {
        setState(() async {
          _mymobileNumber = '';
          await checkMobileNumber(context: context);
        });
      }
    } catch (e) {
      setState(() async {
        _mymobileNumber = '';
        await checkMobileNumber(context: context);
      });
    }

    try {
      final service = await GlobalVariables.getService();
      if (service == true) {
        setState(() {
          _service = true;
        });
      } else {
        setState(() {
          _service = false;
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        _service = false;
      });
    }
  }

  void _startListening() {
    if (path != "") {
      print('listening for changes from firebase');
      DatabaseReference ref = FirebaseDatabase.instance.ref(path);
// Get the Stream
      Stream<DatabaseEvent> stream = ref.onValue;

// Subscribe to the stream!
      _firebaseListener = stream.listen((DatabaseEvent event) async {
        try {
          //DataSnapshot snapshot = event.snapshot; // DataSnapshot
          print('change detected updating badges');
          await BadgeServices.updateBadge();
          print(BadgeServices.number);
          Provider.of<NotificationBadgeProvider>(context, listen: false)
              .providerSetBadgeNumber(badgeNumber: (BadgeServices.number));
        } catch (e) {
          print(e);
        }
      });
    }
  }

  @override
  void initState() {
    _startListening();
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
    _getMobileNumber().whenComplete(() {
      setState(() {});
      if ((_mymobileNumber != '') && (_service == false)) {
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

  @override
  void deactivate() {
    _subscription.cancel();
    if (_firebaseListener != null) {
      _firebaseListener.cancel();
    }
    super.deactivate();
  }

  @override
  void dispose() {
    _subscription.cancel();
    if (_firebaseListener != null) {
      _firebaseListener.cancel();
    }
    super.dispose();
  }
}
