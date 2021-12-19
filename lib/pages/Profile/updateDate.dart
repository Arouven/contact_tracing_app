import 'dart:convert';

import 'package:contact_tracing/pages/Profile/profile.dart';
import 'package:contact_tracing/services/databaseServices.dart';
import 'package:contact_tracing/services/globals.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import '../../widgets/drawer.dart';

class UpdateDatePage extends StatefulWidget {
  static const String route = '/updateDate';

  final String dateOfBirth;
  const UpdateDatePage({
    required this.dateOfBirth,
  });
  @override
  _UpdateDatePageState createState() {
    return _UpdateDatePageState();
  }
}

class _UpdateDatePageState extends State<UpdateDatePage> {
  bool _isLoading = false;
  bool _showReload = false;
  String _dateOfBirth = '14-jun-1996'; //2002-12-19 00:00:00.000
  Future _getDOB() async {
    _dateOfBirth = widget.dateOfBirth;
  }

  @override
  void initState() {
    //_getDOB().whenComplete(() => setState(() {}));
    super.initState();
  }

  DateTime _initialDate(DateTime dateNow) {
    print(widget.dateOfBirth.toString());
    print(_dateOfBirth.toString());
    try {
      var existing = DateTime.parse(_dateOfBirth.toLowerCase());
      print(_dateOfBirth);
      print('already have dob in var');
      return DateTime(existing.year, existing.month, existing.day);
    } catch (e) {
      print('exception: ' + e.toString());
      return DateTime(dateNow.year - 18, dateNow.month, dateNow.day);
    }
  }

  Widget _body() {
    var date = new DateTime.now().toString();
    print(date.toString());
    var dateParse = DateTime.parse(date);

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
                    dateParse.year,
                    dateParse.month,
                    dateParse.day,
                  ),

                  initialDate: _initialDate(dateParse), //-18 yrs
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
                      color: Theme.of(context).accentColor,
                    ),
                    // dividerColor: Colors.blue,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
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
                setState(() {
                  _isLoading = true;
                });
                final email = await GlobalVariables.getEmail();
                try {
                  final response =
                      await DatabaseMySQLServices.updateDateOfBirth(
                          email: email, dateOfBirth: _dateOfBirth);
                  final json = jsonDecode(response.body);
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
