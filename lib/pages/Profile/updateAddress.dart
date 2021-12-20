import 'dart:convert';

import 'package:contact_tracing/pages/Profile/profile.dart';
import 'package:contact_tracing/services/databaseServices.dart';
import 'package:contact_tracing/services/globals.dart';
import 'package:contact_tracing/widgets/commonWidgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import '../../widgets/drawer.dart';

class UpdateAddressPage extends StatefulWidget {
  static const String route = '/updateAddress';

  final String address;
  const UpdateAddressPage({
    required this.address,
  });
  @override
  _UpdateAddressPageState createState() {
    return _UpdateAddressPageState();
  }
}

class _UpdateAddressPageState extends State<UpdateAddressPage> {
  bool _showReload = false;
  bool _isLoading = true;
  // String _firstName = '';
  // String _lastName = '';
  bool _invalidAddress = false;
  TextEditingController _addressController = TextEditingController();
  Future _getData() async {
    _addressController.text = widget.address;
  }

  @override
  void initState() {
    _getData().whenComplete(() => setState(() {
          _isLoading = false;
        }));
    super.initState();
  }

  Widget _body() {
    if (_isLoading) {
      //loading
      return Aesthetic.displayCircle();
    } else if (_showReload) {
      return Center(
        child: FloatingActionButton(
            foregroundColor: Colors.red,
            backgroundColor: Colors.white,
            child: Icon(Icons.replay),
            onPressed: () {
              setState(() {
                _showReload = false;
              });
            }),
      );
    } else {
      return Container(
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
          ],
        ),
      );
    }
  }

  Future _updateAddress() async {
    setState(() {
      _isLoading = true;
    });
    final email = await GlobalVariables.getEmail();
    try {
      final response = await DatabaseMySQLServices.updateAddress(
        email: email,
        address: _addressController.text.trim(),
      );
      print(response);

      setState(() {
        _isLoading = false;
      });
      print('poping the screen');
      Navigator.pop(context, _addressController.text.trim());
    } catch (e) {
      print(e);
      setState(() {
        _isLoading = false;
        _showReload = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        top: true,
        bottom: true,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Update Address'),
            centerTitle: true,
            leading: BackButton(
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.done,
                ),
                onPressed: () async {
                  setState(() {
                    _addressController.text.isEmpty
                        ? _invalidAddress = true
                        : _invalidAddress = false;
                  });
                  if (_invalidAddress == false) {
                    return showDialog<void>(
                      context: context,
                      barrierDismissible: false, // user must tap button!
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                            'Update Address',
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
                                          'Are you sure you want to update the your address?'),
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
                              child: Text('Update'),
                              onPressed: () async {
                                Navigator.of(context).pop();
                                await _updateAddress();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
              ),
            ],
          ),
          drawer: buildDrawer(context, ProfilePage.route),
          body: _body(),
        ),
      ),
    );
  }
}
