import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:contact_tracing/main.dart';
import 'package:contact_tracing/pages/Mobile/mobiles.dart';
import 'package:contact_tracing/pages/Profile/updateAddress.dart';
import 'package:contact_tracing/pages/Profile/updateDate.dart';
import 'package:contact_tracing/pages/Profile/updateName.dart';
import 'package:contact_tracing/providers/notificationbadgemanager.dart';
import 'package:contact_tracing/services/badgeservices.dart';
import 'package:contact_tracing/services/databaseServices.dart';
import 'package:contact_tracing/services/globals.dart';
import 'package:contact_tracing/widgets/commonWidgets.dart';
import 'package:contact_tracing/widgets/drawer.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  static const String route = '/profile';

  @override
  _ProfilePageState createState() {
    return _ProfilePageState();
  }
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isLoading = true;

  late var _subscription;
  late var _firebaseListener = null;
  bool _internetConnection = true;

  String _email = '';
  String _address = '';
  String _dateOfBirth = '';
  String _phones = '';
  String _firstName = "";
  String _lastName = "";
  Future _getData() async {
    final email = await GlobalVariables.getEmail();
    print(email);
    final response =
        jsonDecode(await DatabaseMySQLServices.getUserInfo(email: email));
    print(response);
    if (response != null) {
      _email = response[0]['email'];
      _firstName = response[0]['firstName'];
      _lastName = response[0]['lastName'];
      _address = response[0]['address'];
      _dateOfBirth = response[0]['dateOfBirth'];
      _phones = response[0]['mobiles'];
    }
  }

  Future _updateWidget() async {
    int badgenumber = await GlobalVariables.getBadgeNumber();
    print(badgenumber.toString());
    Provider.of<NotificationBadgeProvider>(context, listen: false)
        .providerSetBadgeNumber(badgeNumber: (badgenumber));
  }

  @override
  void initState() {
    _updateWidget().whenComplete(() {});
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
          GlobalVariables.getBadgeNumber().then((badgenumber) {
            print(badgenumber.toString());
            Provider.of<NotificationBadgeProvider>(context, listen: false)
                .providerSetBadgeNumber(badgeNumber: (badgenumber));
          });
          // print(BadgeServices.number);
          // Provider.of<NotificationBadgeProvider>(context, listen: false)
          //     .providerSetBadgeNumber(badgeNumber: (BadgeServices.number));
        } catch (e) {
          print(e);
        }
      });
    }
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
    _getData().whenComplete(() => setState(() async {
          _isLoading = false;
          await checkMobileNumber(context: context);
        }));
    super.initState();
  }

  _body() {
    var listview = ListView(
      children: [
        ListTile(
          title: Text(
            'Email:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            _email,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        ListTile(
          title: Text(
            'Name:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            "$_firstName $_lastName",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          trailing: IconButton(
            iconSize: 20.0,
            icon: Icon(
              Icons.edit,
            ),
            onPressed: () async {
              print('pressed');

              final data = await Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => UpdateNamePage(
                  firstName: _firstName,
                  lastName: _lastName,
                ),
              ));
//               final data = {
//                 "firstName": _firstName.trim(),
//                 "lastName": _lastName.trim(),
//               };
              if (data != null) {
                setState(() {
                  _firstName = data['firstName'];
                  _lastName = data['lastName'];
                });
              }
            },
          ),
        ),
        ListTile(
          title: Text(
            'Address:',
            // maxLines: 1,
            //overflow: TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            //lipsum.createText(numParagraphs: 10, numSentences: 5),
            _address,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.justify,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          trailing: IconButton(
            iconSize: 20.0,
            icon: Icon(
              Icons.edit,
            ),
            onPressed: () async {
              print('pressed');

              final address =
                  await Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => UpdateAddressPage(
                  address: _address,
                ),
              ));
              if (address != null) {
                setState(() {
                  _address = address;
                });
              }
            },
          ),
        ),
        ListTile(
          title: Text(
            'Date of birth:',
            // maxLines: 1,
            //overflow: TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            (_dateOfBirth != '')
                ? DateFormat('dd-MMM-yyyy')
                    .format(DateTime.parse(_dateOfBirth + ' 00:00:00.000'))
                : '',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          trailing: IconButton(
            iconSize: 20.0,
            icon: Icon(
              Icons.edit,
            ),
            onPressed: () async {
              print('pressed');
              try {
                final String getdate =
                    await Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => UpdateDatePage(
                    dateOfBirth: _dateOfBirth,
                  ),
                ));
                if (getdate != null) {
                  setState(() {
                    _dateOfBirth = getdate.replaceAll(
                        ' 00:00:00.000', ''); //remove  ' 00:00:00.000'
                  });
                }
              } catch (e) {
                print(e);
              }
            },
          ),
        ),
        ListTile(
          title: Text(
            'Phone(s):',
            // maxLines: 1,
            //overflow: TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            _phones,
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          trailing: IconButton(
            iconSize: 20.0,
            icon: Icon(
              Icons.edit,
            ),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (BuildContext context) => MobilePage(),
                ),
                (route) => false,
              );
            },
          ),
        ),
      ],
    );
    if (_internetConnection == false) {
      return Aesthetic.displayNoConnection();
    } else {
      if (_isLoading) {
        //loading
        return Aesthetic.displayCircle();
      } else {
        // if (_address == '') {
        //   return Container();
        // } else {
        return RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(Duration(seconds: 2));
            await _getData();
            setState(() {
              print('pull to refresh');
              _isLoading = false;
            });
          },
          child: listview,
        );
        // }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    //var moblies = ApiProfile.getProfiles();
    return Container(
      //  color: Colors.white,
      child: SafeArea(
        top: true,
        bottom: true,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Profile'),
            centerTitle: true,
            actions: [
              IconButton(
                icon: Icon(
                  Icons.power_settings_new_rounded,
                  color: Colors.red,
                ),
                onPressed: () async {
                  return showDialog<void>(
                    context: context,
                    barrierDismissible: false, // user must tap button!
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(
                          'Logout?',
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: <Widget>[
                              new Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                        'Are you sure you want to log out from the application?'),
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
                            child: Text('Log out'),
                            onPressed: () async {
                              print('logout');
                              Navigator.of(context).pop();
                              await logout(context);
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],

            // backgroundColor: Colors.blue,
          ),
          drawer: buildDrawer(context, ProfilePage.route),
          body: _body(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _subscription.cancel();
    if (_firebaseListener != null) {
      _firebaseListener.cancel();
    }
    super.dispose();
  }

  @override
  void deactivate() {
    _subscription.cancel();
    if (_firebaseListener != null) {
      _firebaseListener.cancel();
    }
    super.deactivate();
  }
}

// import 'package:flutter/material.dart';

// class UserProfile extends StatefulWidget {
//   const UserProfile({Key? key}) : super(key: key);

//   @override
//   _UserProfileState createState() => _UserProfileState();
// }

// class _UserProfileState extends State<UserProfile> {
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return Stack(
//       fit: StackFit.expand,
//       children: <Widget>[
//         Container(
//           decoration: BoxDecoration(
//               gradient: LinearGradient(
//             colors: [
//               Color.fromRGBO(4, 9, 35, 1),
//               Color.fromRGBO(39, 105, 171, 1),
//             ],
//             begin: FractionalOffset.bottomCenter,
//             end: FractionalOffset.topCenter,
//           )),
//         ),
//         Scaffold(
//           backgroundColor: Colors.transparent,
//           body: SingleChildScrollView(
//             physics: BouncingScrollPhysics(),
//             child: Padding(
//               padding:
//                   const EdgeInsets.symmetric(horizontal: 15.0, vertical: 34.0),
//               child: Column(
//                 children: <Widget>[
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: <Widget>[
//                       Icon(
//                         Icons.verified_user_outlined,
//                         color: Colors.white,
//                       ),
//                       Icon(
//                         Icons.logout,
//                         color: Colors.white,
//                       ),
//                     ],
//                   ),
//                   SizedBox(
//                     height: 20,
//                   ),
//                   Text(
//                     "mY Profile",
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 30,
//                       fontFamily: 'Arial',
//                     ),
//                   ),
//                   SizedBox(
//                     height: 20,
//                   ),
//                   Container(
//                     height: size.height * 0.4,
//                     width: size.width,
//                     child: LayoutBuilder(
//                       builder: (context, constraints) {
//                         double innerHeight = constraints.maxHeight;
//                         double innerWidth = constraints.maxWidth;
//                         return Stack(
//                           fit: StackFit.expand,
//                           children: <Widget>[
//                             Positioned(
//                               bottom: 0,
//                               left: 0,
//                               right: 0,
//                               child: Container(
//                                 height: innerHeight * 0.65,
//                                 width: innerWidth,
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(30),
//                                   color: Colors.white,
//                                 ),
//                                 child: Column(
//                                   children: <Widget>[
//                                     SizedBox(
//                                       height: 70,
//                                     ),
//                                     Text(
//                                       "Pascal St Louis",
//                                       style: TextStyle(
//                                         color: Color.fromRGBO(39, 105, 171, 1),
//                                         fontFamily: 'Arial',
//                                         fontSize: 32,
//                                       ),
//                                     ),
//                                     Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.center,
//                                       children: <Widget>[
//                                         Column(
//                                           children: <Widget>[
//                                             Text(
//                                               "User Id",
//                                               style: TextStyle(
//                                                 color: Colors.grey[900],
//                                                 fontFamily: 'Arial',
//                                                 fontSize: 21,
//                                               ),
//                                             ),
//                                             Text(
//                                               "1",
//                                               style: TextStyle(
//                                                 color: Color.fromRGBO(
//                                                     39, 105, 171, 1),
//                                                 fontFamily: 'Arial',
//                                                 fontSize: 21,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                         Padding(
//                                           padding: const EdgeInsets.all(20.0),
//                                           child: Container(
//                                             height: 40,
//                                             width: 2,
//                                             decoration: BoxDecoration(
//                                               borderRadius:
//                                                   BorderRadius.circular(100),
//                                               color: Colors.green[900],
//                                             ),
//                                           ),
//                                         ),
//                                         Column(
//                                           children: <Widget>[
//                                             Text(
//                                               "Plots",
//                                               style: TextStyle(
//                                                 color: Colors.grey[900],
//                                                 fontFamily: 'Arial',
//                                                 fontSize: 21,
//                                               ),
//                                             ),
//                                             Text(
//                                               "1",
//                                               style: TextStyle(
//                                                 color: Color.fromRGBO(
//                                                     39, 105, 171, 1),
//                                                 fontFamily: 'Arial',
//                                                 fontSize: 21,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                         Padding(
//                                           padding: const EdgeInsets.all(20.0),
//                                           child: Container(
//                                             height: 40,
//                                             width: 2,
//                                             decoration: BoxDecoration(
//                                               borderRadius:
//                                                   BorderRadius.circular(100),
//                                               color: Colors.green[900],
//                                             ),
//                                           ),
//                                         ),
//                                         Column(
//                                           children: <Widget>[
//                                             Text(
//                                               "Crops",
//                                               style: TextStyle(
//                                                 color: Colors.grey[900],
//                                                 fontFamily: 'Arial',
//                                                 fontSize: 21,
//                                               ),
//                                             ),
//                                             Text(
//                                               "1",
//                                               style: TextStyle(
//                                                 color: Color.fromRGBO(
//                                                     39, 105, 171, 1),
//                                                 fontFamily: 'Arial',
//                                                 fontSize: 21,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ],
//                                     )
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             Positioned(
//                               top: 0,
//                               left: 0,
//                               right: 0,
//                               child: Center(
//                                 child: Container(
//                                   child: Image.asset(
//                                     "assets/images/user.png",
//                                     fit: BoxFit.fitWidth,
//                                     width: innerWidth * 0.45,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         );
//                       },
//                     ),
//                   ),
//                   SizedBox(
//                     height: 25,
//                   ),
//                   Container(
//                     height: size.height * 0.5,
//                     width: size.width,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(30),
//                       color: Colors.white,
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 15),
//                       child: Column(
//                         children: <Widget>[
//                           SizedBox(
//                             height: 20,
//                           ),
//                           Text(
//                             "My Personal Details",
//                             style: TextStyle(
//                               color: Colors.amber,
//                               fontSize: 25,
//                               fontFamily: 'Arial',
//                             ),
//                           ),
//                           Divider(
//                             thickness: 2.5,
//                           ),
//                           SizedBox(
//                             height: 10,
//                           ),
//                           Detail_Box(name: "Address", details: "La bas bro"),
//                           SizedBox(
//                             height: 10,
//                           ),
//                           Detail_Box(name: "Address", details: "La bas bro"),
//                         ],
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ),
//         )
//       ],
//     );
//   }
// }

// class Detail_Box extends StatelessWidget {
//   const Detail_Box({Key? key, required this.name, required this.details})
//       : super(key: key);
//   final String name;
//   final String details;
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.green[50],
//         borderRadius: BorderRadius.circular(30),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(15.0),
//         child: Row(
//           children: <Widget>[
//             Expanded(
//               flex: 1,
//               child: Text(
//                 name,
//                 style: TextStyle(
//                   color: Colors.green[900],
//                   fontSize: 20,
//                   fontFamily: 'Arial',
//                 ),
//               ),
//             ),
//             Expanded(
//               flex: 2,
//               child: Text(
//                 details,
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontSize: 15,
//                   fontFamily: 'Arial',
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
