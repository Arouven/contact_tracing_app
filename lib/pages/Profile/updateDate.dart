import 'dart:convert';

import 'package:contact_tracing/pages/Profile/profile.dart';
import 'package:contact_tracing/services/databaseServices.dart';
import 'package:contact_tracing/services/globals.dart';
import 'package:contact_tracing/widgets/commonWidgets.dart';
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
  bool _showReload = false;
  bool _isLoading = true;
  String _dateOfBirth = '';
  Future _getDOB() async {
    _dateOfBirth = widget.dateOfBirth;
  }

  @override
  void initState() {
    _getDOB().whenComplete(() => setState(() {
          _isLoading = false;
        }));
    super.initState();
  }

  Widget _body() {
    var date = new DateTime.now().toString();
    print(date.toString());
    var dateParse = DateTime.parse(date);

    var initialdate = DateTime(
      DateTime.parse(_dateOfBirth).year,
      DateTime.parse(_dateOfBirth).month,
      DateTime.parse(_dateOfBirth).day,
    );
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

                    initialDate: initialdate,
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
                  setState(() {
                    _isLoading = false;
                  });
                  Navigator.of(context).pop();
                } catch (e) {
                  print(e);
                  setState(() {
                    _isLoading = false;
                    _showReload = true;
                  });
                }
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
