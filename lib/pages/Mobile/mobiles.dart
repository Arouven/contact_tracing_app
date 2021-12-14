import 'dart:async';
import 'package:contact_tracing/services/apiMobile.dart';
import 'package:contact_tracing/services/auth.dart';
import 'package:contact_tracing/services/databaseServices.dart';
import 'package:contact_tracing/widgets/commonWidgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:contact_tracing/models/mobile.dart';
import 'package:contact_tracing/pages/Mobile/addMobile.dart';
import 'package:contact_tracing/pages/Mobile/updateMobile.dart';
import '../../widgets/drawer.dart';

// class MobilePage extends StatefulWidget {
//   static const String route = '/mobiles';

//   @override
//   _MobilePageState createState() {
//     print("in mobiles");
//     return _MobilePageState();
//   }
// }

// class _MobilePageState extends State<MobilePage> {
//   //declaring variables
//   late SharedPreferences prefs;
//   bool _isLoading = true;
//   bool _showReload = false;
//   late int _selectedRadioTile;
//   int _myMobileId = 0;
//   bool _findSelected = false;
//   late var _mobiles;

//   /// set the shared pref
//   /// mark the radio button with [val]
//   Future<void> _setSelectedRadioTile(int val) async {
//     setState(() {
//       _selectedRadioTile = val;
//     });
//     prefs = await SharedPreferences.getInstance();
//     await prefs.setString(
//       'mobileId',
//       val.toString(),
//     ); //update new mobileid in shared pref
//     String? fcmtoken = await FirebaseAuthenticate().getfirebasefcmtoken();
//     await DatabaseServices()
//         .updateMobilefmcToken(mobileId: val.toString(), fcmtoken: fcmtoken!);
//   }

//   /// get the mobile id of the user and set it in [_myMobileId]
//   Future<void> _getMyMobileId() async {
//     prefs = await SharedPreferences.getInstance();
//     try {
//       //convert to integer and send it to _myMobileId
//       _myMobileId = int.parse(prefs.getString("mobileId") as String);
//     } catch (exception) {
//       print(exception); //print the errors
//     }
//   }

//   /// display dialog
//   /// if the user is sure he/she want to change [mobile]
//   Future<void> _showEditDialog(Mobile mobile) {
//     return showDialog<void>(
//       context: context,
//       barrierDismissible: false, // user must tap button!
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text(
//             'Modify Mobile',
//             style: TextStyle(
//               color: Colors.orange,
//             ),
//           ),
//           content: SingleChildScrollView(
//             child: ListBody(
//               children: <Widget>[
//                 new Row(
//                   children: [
//                     Expanded(
//                       child: Text(
//                           'Are you sure you want to make changes to "${mobile.mobileName}" mobile?'),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('Cancel'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               child: const Text('Modify'),
//               onPressed: () {
//                 // open a UpdateMobilePage with parameter [mobile]
//                 Navigator.of(context).push(
//                   MaterialPageRoute(
//                     builder: (BuildContext context) =>
//                         UpdateMobilePage(mobile: mobile),
//                   ),
//                 );
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   /// take [mobiles] as List<Mobile>
//   /// build the radio buttons with text
//   /// return the list<Widget>
//   List<Widget> _buildMobiles(List<Mobile> mobiles) {
//     List<Widget> widgets = [];
//     if (mobiles == null) {
//       //if there is no mobiles stop
//       return widgets;
//     }

//     for (Mobile mobile in mobiles) {
//       if (_findSelected) {
//         _setSelectedRadioTile(mobile.mobileId);
//         widgets.add(
//           RadioListTile(
//             groupValue: mobile.mobileId,
//             value: mobile.mobileId,
//             onChanged: (val) async {
//               print("val = $val, selected tile = $_selectedRadioTile");
//               await _setSelectedRadioTile(val as int);
//             },
//             title: Text(
//               mobile.mobileName,
//             ),
//             subtitle: Text(
//               mobile.mobileNumber,
//             ),
//             secondary: new IconButton(
//               icon: new Icon(Icons.edit),
//               onPressed: () {
//                 print('mobile press');
//                 _showEditDialog(mobile);
//               },
//             ),
//           ),
//         );
//         _findSelected = false;
//       } else {
//         widgets.add(
//           RadioListTile(
//             groupValue: _selectedRadioTile,
//             value: mobile.mobileId,
//             onChanged: (val) {
//               print("val = $val, selected tile = $_selectedRadioTile");
//               _setSelectedRadioTile(val as int);
//             },
//             title: Text(
//               mobile.mobileName,
//             ),
//             subtitle: Text(
//               mobile.mobileNumber,
//             ),
//             secondary: IconButton(
//               icon: Icon(Icons.edit),
//               onPressed: () {
//                 print('mobile press');
//                 _showEditDialog(mobile);
//               },
//             ),
//           ),
//         );
//       }
//     }
//     widgets.add(
//       ListTile(),
//     );
//     return widgets;
//   }

//   /// return the body of the page
//   Widget _body() {
//     if (_isLoading == true) {
//       return Center(child: CircularProgressIndicator());
//     } else if (_showReload == true) {
//       return Center(
//         child: FloatingActionButton(
//             foregroundColor: Colors.red,
//             backgroundColor: Colors.white,
//             child: Icon(Icons.replay),
//             onPressed: () {
//               Navigator.of(context).pushReplacement(MaterialPageRoute(
//                 builder: (BuildContext context) => MobilePage(),
//               ));
//             }),
//       );
//     } else {
//       return SingleChildScrollView(
//         child: Column(
//           children: _buildMobiles(_mobiles),
//         ),
//       );
//     }
//   }

//   /// display the add button
//   /// if is not loading and has not encounter error
//   Widget? _floatingActionButton() {
//     if (_isLoading) {
//       return null;
//     } else if (_showReload) {
//       return null;
//     } else {
//       return FloatingActionButton(
//           child: Icon(
//             Icons.add,
//           ),
//           onPressed: () {
//             setState(() {
//               _isLoading = true;
//             });
//             Navigator.of(context).push(MaterialPageRoute(
//               builder: (BuildContext context) => AddMobilePage(),
//             ));
//           });
//     }
//   }

//   @override
//   void initState() {
//     _getMyMobileId().whenComplete(() => setState(() {
//           //if mobileid in database not matches users current mobileid.
//           //set the radio button to 0.
//           // means that we have to find
//           if (_myMobileId == 0) {
//             _findSelected = true;
//             _selectedRadioTile = 0;
//           } else {
//             _findSelected = false;
//             _selectedRadioTile = _myMobileId;
//           }
//         }));
//     ApiMobile.getMobiles().then((mobileList) => setState(() {
//           _mobiles = mobileList;
//           _isLoading = false;
//           print('is loading false');

//           try {
//             if (mobileList != null) {
//               final mobileMap = mobileList.asMap();
//               Mobile firstMobileInList = mobileMap[0] as Mobile;
//               if (firstMobileInList.mobileId == 0) {
//                 _showReload = true;
//                 print('show reload is true');
//               } else if ((mobileList.length == 1) ||
//                   (prefs.getBool('justLogin') == true)) {
//                 //add the first mobile
//                 print(
//                     'add the first mobile and start service || logged in and have mobile(s), start services and remove justLogin');
//                 _setSelectedRadioTile(firstMobileInList.mobileId);
//                 prefs.remove('justLogin');
//                 //  start bg services
//                 FlutterBackgroundService().sendData({"action": "startService"});
//               }
//             } else {}
//           } catch (e) {
//             print(e.toString());
//             _showReload = true;
//           }
//         }));
//     super.initState();
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
//             title: Text('Mobiles'),
//             centerTitle: true,
//             backgroundColor: Colors.blue,
//           ),
//           drawer: buildDrawer(context, MobilePage.route),
//           body: _body(),
//           floatingActionButton: _floatingActionButton(),
//         ),
//       ),
//     );
//   }
// }

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
  late SharedPreferences prefs;
  bool _isLoading = true;
  bool _showReload = false;
  late int _selectedRadioTile;
  int _myMobileId = 0;
  bool _findSelected = false;
  late var _mobiles;
  late var myfcmtoken;

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
  Future<void> _showAddDialog() {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Add Mobile',
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
                          'Seems that your mobile is not in our database. Please Add it!'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (BuildContext context) => AddMobilePage(),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
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
                final response = await DatabaseServices().updateMobilefmcToken(
                  mobileId: mobile.mobileId.toString(),
                  fcmtoken: fcmtoken!,
                );
                Navigator.of(context).pop();
                if (response != 'Error') {
                  if (response['msg'] == 'success') {
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
  List<Widget> _buildMobiles(List<Mobile> mobiles) {
    List<Widget> widgets = [];
    // bool inList = false;
    // for (Mobile mobile in mobiles) {
    //   if (myfcmtoken.toString() == mobile.fcmtoken.toString()) {
    //     inList = true;
    //     break;
    //   }
    // }
    if ((mobiles == null)) {
      //if there is no mobiles stop
      // _showAddDialog();
      DialogBox.showErrorDialog(
        context: context,
        title: 'No Mobile!',
        body: 'Click on the plus sign below to add your mobile',
      );
      print('mobile is null');
      return widgets;
    } else {
      for (Mobile mobile in mobiles) {
        widgets.add(
          ListTile(
            title: Text(
              mobile.mobileName,
              style: (myfcmtoken.toString() == mobile.fcmtoken.toString())
                  ? TextStyle(fontWeight: FontWeight.bold)
                  : null,
            ),
            subtitle: (myfcmtoken.toString() == mobile.fcmtoken.toString())
                ? Text(
                    'Active',
                    style: TextStyle(
                      color: Colors.green,
                    ),
                  )
                : null,
            trailing: // IconButton(onPressed: onPressed, icon: icon)

                PopupMenuButton(
                    itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                          PopupMenuItem(
                            child: TextButton(
                              child: const Text(
                                'Set Active',
                                style: TextStyle(color: Colors.black),
                              ),
                              onPressed: () {
                                setActive(mobile);
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
                                editmobile(mobile);
                              },
                            ),
                          )
                        ]),
          ),
        );
      }
      widgets.add(
        ListTile(),
      );
      return widgets;
    }
  }

  /// return the body of the page
  Widget _body() {
    if (_isLoading == true) {
      return Center(child: CircularProgressIndicator());
    } else if (_showReload == true) {
      return Center(
        child: FloatingActionButton(
            foregroundColor: Colors.red,
            backgroundColor: Colors.white,
            child: Icon(Icons.replay),
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => MobilePage(),
              ));
            }),
      );
    } else {
      return SingleChildScrollView(
        child: Column(
          children: _buildMobiles(_mobiles),
        ),
      );
    }
  }

  /// display the add button
  /// if is not loading and has not encounter error
  Widget? _floatingActionButton() {
    if (_isLoading) {
      return null;
    } else if (_showReload) {
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

  @override
  void initState() {
    FirebaseAuthenticate().getfirebasefcmtoken().then((value) => setState(() {
          myfcmtoken = value;
        }));

    ApiMobile.getMobiles().then((mobileList) => setState(() {
          _mobiles = mobileList;
          _isLoading = false;
          print('is loading false');
          if (mobileList != null) {
            print('mobilelist is not null');

            //  start bg services
            // FlutterBackgroundService().sendData({"action": "startService"});
          }
        }));
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
