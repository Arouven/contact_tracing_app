import 'dart:async';
import 'package:contact_tracing/services/apiMobile.dart';
import 'package:contact_tracing/services/auth.dart';
import 'package:contact_tracing/services/databaseServices.dart';
import 'package:contact_tracing/services/globals.dart';
import 'package:contact_tracing/widgets/commonWidgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:contact_tracing/models/mobile.dart';
import 'package:contact_tracing/pages/Mobile/addMobile.dart';
import 'package:contact_tracing/pages/Mobile/updateMobile.dart';
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
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Modify'),
              onPressed: () {
                // open a UpdateMobilePage with parameter [mobile]
                Navigator.of(context).push(
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
  //    DialogBox.factoryshowErrorDialog(context:context,
  //    title : 'Add Mobile',
  //    body : 'It seems that your mobile is not on our database. Please add it!',
  //    titleColor : Colors.orange,
  // );

  /// display add mobile dialog
  // Future<void> _showAddDialog() {
  //   return showDialog<void>(
  //     context: context,
  //     barrierDismissible: false, // user must tap button!
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text(
  //           'Add Mobile',
  //           style: TextStyle(
  //             color: Colors.orange,
  //           ),
  //         ),
  //         content: SingleChildScrollView(
  //           child: ListBody(
  //             children: <Widget>[
  //               new Row(
  //                 children: [
  //                   Expanded(
  //                     child: Text(
  //                         'Seems that your mobile is not in our database. Please Add it!'),
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ),
  //         actions: <Widget>[
  //           TextButton(
  //             child: const Text('Add'),
  //             onPressed: () {
  //               Navigator.of(context).pushReplacement(
  //                 MaterialPageRoute(
  //                   builder: (BuildContext context) => AddMobilePage(),
  //                 ),
  //               );
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

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
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () async {
                String? fcmtoken =
                    await FirebaseAuthenticate().getfirebasefcmtoken();
                final response =
                    await DatabaseMySQLServices.updateMobilefmcToken(
                  mobileNumber: mobile.mobileNumber,
                  fcmtoken: fcmtoken!,
                );
                Navigator.of(context).pop();
                if (response != 'Error') {
                  if (response['msg'] == 'success') {
                    await GlobalVariables.setMobileNumber(
                      mobileNumber: mobile.mobileNumber,
                    );
                    setState(() {
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
                } else {
                  DialogBox.showErrorDialog(
                    context: context,
                    title: 'Error Happened',
                    body: 'An Error occur, please retry',
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  setActive(Mobile mobile) {
    print('set active');
    _showSetActiveDialog(mobile);
    print(mobile.fcmtoken);
  }

  editmobile(Mobile mobile) {
    print('editmobile');
    _showEditDialog(mobile);
    print(mobile.fcmtoken);
  }

  /// take [mobiles] as List<Mobile>
  /// build the radio buttons with text
  /// return the list<Widget>
  Widget _buildMobiles() {
    print('building mobiles');
    //List<Widget> widgets = [];
    // bool inList = false;
    // for (Mobile mobile in mobiles) {
    //   if (myfcmtoken.toString() == mobile.fcmtoken.toString()) {
    //     inList = true;
    //     break;
    //   }
    // }

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
                    trailing: // IconButton(onPressed: onPressed, icon: icon)

                        PopupMenuButton(
                            itemBuilder: (BuildContext context) =>
                                <PopupMenuEntry>[
                                  PopupMenuItem(
                                    child: TextButton(
                                      child: const Text(
                                        'Set Active',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      onPressed: () {
                                        setActive(_mobiles[index]);
                                      },
                                    ),
                                  ),
                                  PopupMenuItem(
                                    child: TextButton(
                                      child: const Text(
                                        'Edit Mobile',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      onPressed: () {
                                        editmobile(_mobiles[index]);
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
      return _buildMobiles();
    }
  }

  /// display the add button
  /// if is not loading and has not encounter error
  Widget? _floatingActionButton() {
    if (_isLoading) {
      return null;
    }
    // else if (_showReload) {
    //   return null;
    // }
    else {
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

  Future getMobileNumber() async {
    final mNum = await GlobalVariables.getMobileNumber();
    if (mNum != null) {
      return mNum;
    }
    return '';
  }

  @override
  void initState() {
    getMobileNumber().then((value) => setState(() {
          _mymobileNumber = value;
        }));
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

    super.initState();
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
            title: Text('Mobiles'),
            centerTitle: true,
            backgroundColor: Colors.blue,
          ),
          drawer: buildDrawer(context, MobilePage.route),
          body: _body(),
          floatingActionButton: _floatingActionButton(),
        ),
      ),
    );
  }
}
