import 'package:contact_tracing/pages/Profile/profile.dart';
import 'package:contact_tracing/services/databaseServices.dart';
import 'package:contact_tracing/services/globals.dart';
import 'package:contact_tracing/widgets/commonWidgets.dart';
import 'package:contact_tracing/widgets/drawer.dart';
import 'package:flutter/material.dart';

class UpdateNamePage extends StatefulWidget {
  static const String route = '/updateName';

  final String firstName;
  final String lastName;
  const UpdateNamePage({
    required this.firstName,
    required this.lastName,
  });
  @override
  _UpdateNamePageState createState() {
    return _UpdateNamePageState();
  }
}

class _UpdateNamePageState extends State<UpdateNamePage> {
  bool _showReload = false;
  bool _isLoading = true;
  // String _firstName = '';
  // String _lastName = '';
  bool _invalidFirstName = false;
  bool _invalidLastName = false;
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  Future _getData() async {
    _firstNameController.text = widget.firstName;
    _lastNameController.text = widget.lastName;
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
                controller: _firstNameController,
                decoration: new InputDecoration(
                  labelText: 'First Name',
                  errorText:
                      _invalidFirstName ? 'First Name Can\'t Be Empty' : null,
                ),
              ),
            ),
            ListTile(
              title: TextField(
                controller: _lastNameController,
                decoration: new InputDecoration(
                  labelText: 'Last Name',
                  errorText:
                      _invalidLastName ? 'Last Name Can\'t Be Empty' : null,
                ),
              ),
            ),
          ],
        ),
      );

      //   return SingleChildScrollView(
      //     child: new Column(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       crossAxisAlignment: CrossAxisAlignment.center,
      //       children: [
      //         new Container(
      //           child: new Text(
      //             'Date of birth',
      //             style: TextStyle(
      //               fontSize: 40.0,
      //             ),
      //           ),
      //         ),
      //         SizedBox(
      //           height: MediaQuery.of(context).size.height / 2, // / 1.3,
      //           child: Center(
      //             child: new Container(
      //               alignment: Alignment.center,
      //               child: new DatePickerWidget(
      //                 looping: true, // default is not looping
      //                 lastDate: DateTime(
      //                   dateParse.year,
      //                   dateParse.month,
      //                   dateParse.day,
      //                 ),

      //                 initialDate: initialdate,
      //                 dateFormat: "dd-MMM-yyyy",
      //                 locale: DatePicker.localeFromString('en'),
      //                 onChange: (DateTime newDate, _) {
      //                   _dateOfBirth = newDate.toString();
      //                   print(_dateOfBirth);
      //                 },
      //                 pickerTheme: DateTimePickerTheme(
      //                   backgroundColor: Colors.transparent,
      //                   itemTextStyle: TextStyle(
      //                     fontSize: 19,
      //                     color: Theme.of(context).accentColor,
      //                   ),
      //                   // dividerColor: Colors.blue,
      //                 ),
      //               ),
      //             ),
      //           ),
      //         ),
      //       ],
      //     ),
      //   );
    }
  }

  Future _updateNames() async {
    setState(() {
      _isLoading = true;
    });
    final email = await GlobalVariables.getEmail();
    try {
      final response = await DatabaseMySQLServices.updateName(
        email: email,
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
      );
      print(response);
      final data = {
        "firstName": _firstNameController.text.trim(),
        "lastName": _lastNameController.text.trim(),
      };
      print(data);
      setState(() {
        _isLoading = false;
      });
      print('poping the screen');
      Navigator.pop(context, data);
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
            title: Text('Update Names'),
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
                    _firstNameController.text.isEmpty
                        ? _invalidFirstName = true
                        : _invalidFirstName = false;
                    _lastNameController.text.isEmpty
                        ? _invalidLastName = true
                        : _invalidLastName = false;
                    // (_isEmail(_emailController.text.trim()))
                    //     ? _invalidEmail = false
                    //     : _invalidEmail = true;
                  });
                  if (_invalidFirstName == false && _invalidLastName == false) {
                    return showDialog<void>(
                      context: context,
                      barrierDismissible: false, // user must tap button!
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                            'Update Names',
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
                                          'Are you sure you want to update the names?'),
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
                              child: Text('Update'),
                              onPressed: () async {
                                Navigator.of(context).pop();
                                await _updateNames();
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
