// import 'package:contact_tracing/classes/globals.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong/latlong.dart';
// import 'package:geolocator/geolocator.dart';
import '../widgets/drawer.dart';

class AddMobilePage extends StatefulWidget {
  static const String route = '/addmobiles';

  @override
  _AddMobilePageState createState() {
    return _AddMobilePageState();
  }
}

// Widget _buildButtons() {
//   return new Container(
//     child: new Column(
//       children: <Widget>[
//         new ElevatedButton(
//           child: new Text('Login'),
//           // onPressed: _loginPressed,
//         ),
//         new TextButton(
//           child: new Text('Dont have an account? Tap here to register.'),
//           // onPressed: _createAccountPressed,
//         ),
//         new TextButton(
//           child: new Text('Forgot Password?'),
//           //onPressed: _passwordReset,
//         )
//       ],
//     ),
//   );
// }

class _AddMobilePageState extends State<AddMobilePage> {
  final mobiles = ['work', 'home'];
  void addItem() {
    setState(() {
      mobiles.add(mobiles[-1]);
    });
  }

  cancelButton() {}
  saveButton() {}
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
              onPressed: cancelButton,
            ),
            automaticallyImplyLeading: true,
            backgroundColor: Colors.blue[100],
            title: Text(
              'New Mobile',
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
                onPressed: saveButton,
              ),
            ],
          ), //AppBar
          // appBar: AppBar(
          //   title: Text('Mobiles'),
          //   actions: [],
          //   centerTitle: true,
          //   backgroundColor: Colors.blue,
          // ),
          //drawer: buildDrawer(context, AddMobilePage.route),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      //textColor: Colors.white,
                      onPressed: () {},
                      child: Text("Cancel"),
                      //shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
                    ),
                    TextButton(
                      //textColor: Colors.white,
                      onPressed: () {},
                      child: Text("Cancel"),
                      //shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
                    ),
                  ],
                ),
                // ListView.separated(
                //   itemCount: mobiles.length,
                //   itemBuilder: (context, index) {
                //     return ListTile(
                //       title: Text(mobiles[index]),
                //     );
                //   },
                //   separatorBuilder: (context, index) {
                //     return Divider();
                //   },
                // ),
              ],
            ),
          ),
          // floatingActionButton: FloatingActionButton(
          //   child: Icon(Icons.add),
          //   onPressed: addItem,
          // ),
        ),
      ),
    );
  }
}
