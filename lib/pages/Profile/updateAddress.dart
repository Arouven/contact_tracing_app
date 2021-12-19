import 'dart:convert';

import 'package:contact_tracing/pages/Profile/profile.dart';
import 'package:contact_tracing/services/databaseServices.dart';
import 'package:contact_tracing/services/globals.dart';
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
  // bool _isLoading = false;
  // bool _showReload = false;
  String _address = 'bambous,mauritiius';
  Future _getAddress() async {
    _address = widget.address;
  }

  @override
  void initState() {
    _getAddress().whenComplete(() => setState(() {}));
    super.initState();
  }

  DateTime _initialDate(DateTime dateNow) {
    try {
      var existing = DateTime.parse(_address);
      print('already have dob in var');
      return DateTime(existing.year, existing.month, existing.day);
    } on Exception {
      print('exception');
      return DateTime(dateNow.year - 18, dateNow.month, dateNow.day);
    }
  }

  Widget _body() {
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        top: true,
        bottom: true,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Update DOB'),
            centerTitle: true,
            leading: BackButton(
              onPressed: () async {
                print(_address);
                // setState(() {
                //   _isLoading = true;
                // });
                // final email = await GlobalVariables.getEmail();
                try {
                  // final response =
                  // await DatabaseMySQLServices.UpdateAddressPage(
                  //     address: _address);
                  // final json = jsonDecode(response.body);
                  Navigator.of(context).pop();
                } catch (e) {}
              },
            ),
          ),
          drawer: buildDrawer(context, ProfilePage.route),
          body: _body(),
        ),
      ),
    );
  }
}
