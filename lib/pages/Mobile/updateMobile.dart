//import 'dart:convert';
import 'dart:io';
import 'package:contact_tracing/services/databaseServices.dart';
//import 'package:contact_tracing/services/globals.dart';
import 'package:device_info/device_info.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
//import '../../classes/globals.dart';
import 'package:contact_tracing/models/mobile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:http/http.dart' as http;
import 'mobiles.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import '../../widgets/commonWidgets.dart';

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

  Future<void> _showAcceptDialog() async {
    if (!_validateDescription && !_validateName && !_validateNumber) {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'Save Change(s)',
              style: TextStyle(color: Colors.orange),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  new Row(
                    children: [
                      Expanded(
                        child: Text(
                            'Are you sure you want to save change(s) made?'),
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
                child: const Text('Accept'),
                onPressed: () async {
                  setState(() {
                    _isLoading = true;
                  });
                  Navigator.of(context).pop();
                  final data = await DatabaseServices().updateMobile(
                    mobileId: widget.mobile.mobileId.toString(),
                    mobileName: _mobileName.text.toString(),
                    mobileDescription: _mobileDescription.text.toString(),
                    mobileNumber: _mobileNumber.toString(),
                  );
                  print(data);
                  if (data != 'Error') {
                    if (data['msg'] == "success") {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => MobilePage()),
                          (e) => false);
                    }
                  } else {
                    setState(() {
                      _showReload = true;
                    });
                  }
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
                        print('hhhhhhhhhhhhhhhhhhhhhhhhh');
                        print(_numwithoutcode);
                        print(number);
                        print(number.phoneNumber);
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
      return Aesthetic.refreshButton(
          route: UpdateMobilePage(mobile: widget.mobile));
    } else {
      return _displayMobile();
    }
  }

  void getPhoneNumber(String phoneNumber) async {
    PhoneNumber number =
        await PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumber, 'MU');

    setState(() {
      this.number = number;
    });
    //print(number);
  }

  @override
  void initState() {
    super.initState();
    initPlatformState().whenComplete(() => setState(() {
          _mobileName.text = widget.mobile.mobileName;
          _mobileDescription.text = widget.mobile.mobileDescription;
          _mobileNumber = widget.mobile.mobileNumber;

          getPhoneNumber(_mobileNumber);
          //print(number);
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
            leading: IconButton(
              icon: Icon(
                Icons.clear_outlined,
                color: Colors.red,
              ),
              onPressed: () {
                DialogBox.showDiscardDialog(
                    context: context, route: MobilePage());
              },
            ),
            automaticallyImplyLeading: true,
            backgroundColor: Colors.blue[100],
            title: Text(
              'Update Mobile',
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
    _mobileName.dispose();
    _mobileDescription.dispose();
    _mobileNumberController.dispose();
    super.dispose();
  }
}
