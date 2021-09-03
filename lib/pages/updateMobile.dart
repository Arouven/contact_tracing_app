import 'dart:convert';

import '../classes/globals.dart';
import 'package:contact_tracing/classes/mobile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'mobiles.dart';

class UpdateMobilePage extends StatefulWidget {
  final Mobile mobile;
  static const String route = '/updateMobile';
  UpdateMobilePage({
    Key key,
    @required this.mobile,
  }) : super(key: key);
  @override
  _UpdateMobilePageState createState() => _UpdateMobilePageState();
}

class _UpdateMobilePageState extends State<UpdateMobilePage> {
  bool _isLoading = true;
  TextEditingController _mobileName = TextEditingController();
  TextEditingController _mobileDescription = TextEditingController();

  Future<void> _showDiscardDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Discard Changes',
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
                          'Are you sure you want to discard changes made?'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
                child: const Text('Yes'),
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => MobilePage()),
                      (e) => false);
                }),
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showAcceptDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Save Changes',
            style: TextStyle(color: Colors.orange),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                new Row(
                  children: [
                    Expanded(
                      child:
                          Text('Are you sure you want to save changes made?'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
                child: const Text('Yes'),
                onPressed: () async {
                  await saveToDb();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => MobilePage()),
                      (e) => false);
                }),
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> saveToDb() async {
    var url = await updateMobileUrl;
    final res = await http.post(Uri.parse(url), body: {
      "mobileId": widget.mobile.mobileId,
      "mobileName": _mobileName.text,
      "mobileDescription": _mobileDescription.text
    });
    final data = jsonDecode(res.body);
    //_displayError = false;
    print(data);
    // if (data['msg'] == "data does not exist") {
    //   //_displayError = true;
    //   _msgError = "Wrong Credentials!";
    //   _username.clear();
    //   _password.clear();
    //   setState(() {
    //     _isLoading = false;
    //     _showMyDialog();
    //   });
    // } else {
    //   _msgError = ""; //"User logged in";
    //   setState(() async {
    //     final SharedPreferences prefs = await SharedPreferences.getInstance();
    //     await prefs.setString('username', _username.text);
    //     await prefs.setString('password', _password.text);
    //     _isLoading = false;
    //     Navigator.of(context).pushAndRemoveUntil(
    //         MaterialPageRoute(builder: (context) => SplashPage()),
    //         (e) => false);
    //   });
    //redirect to home

    //}
  }

  Widget displayCircle() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 1.3,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
          // Padding(
          //   //padding: EdgeInsets.only(top: 16),
          //   child:
          Text('Awaiting result...'),
          // )
        ],
      ),
    );
  }

  Widget displayMobile() {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Center(
        child: ListView(
          children: <Widget>[
            _buildTextFields(),
            Center(
              child: Text(
                'hello',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTextFields() {
    setState(() {
      _mobileName.text = widget.mobile.mobileName;
      _isLoading = false;
    });
    return new Container(
      child: new Column(
        children: <Widget>[
          new Container(
            child: new TextField(
              controller: _mobileName,
              decoration: new InputDecoration(labelText: 'Mobile Name'),
            ),
          ),
          new Container(
            child: new TextField(
              controller: _mobileDescription,
              decoration: new InputDecoration(labelText: 'Mobile Description'),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print(widget.mobile.mobileId);
    print(widget.mobile.mobileName);
    print(widget.mobile.mobileDescription);
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
                _showDiscardDialog();
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
          ), //AppBar
          // appBar: AppBar(
          //   title: Text('Mobiles'),
          //   actions: [],
          //   centerTitle: true,
          //   backgroundColor: Colors.blue,
          // ),
          //drawer: buildDrawer(context, AddMobilePage.route),
          body:
              Expanded(child: displayMobile()), //_isLoading ? displayCircle() :
          //Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Column(
          //     children: [
          //       Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //         children: [
          //           new TextField(
          //             //initialValue: widget.mobile.mobileName,
          //             controller: _mobileName,
          //             decoration: new InputDecoration(labelText: 'Mobile Name'),
          //           ),
          //           // TextButton(
          //           //   //textColor: Colors.white,
          //           //   onPressed: () {},
          //           //   child: Text(mobile.mobileName),
          //           //   //shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
          //           // ),
          //           TextButton(
          //             //textColor: Colors.white,
          //             onPressed: () {},
          //             child: Text(widget.mobile.mobileDescription),
          //             //shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
          //           ),
          //         ],
          //       ),
          //       // ListView.separated(
          //       //   itemCount: mobiles.length,
          //       //   itemBuilder: (context, index) {
          //       //     return ListTile(
          //       //       title: Text(mobiles[index]),
          //       //     );
          //       //   },
          //       //   separatorBuilder: (context, index) {
          //       //     return Divider();
          //       //   },
          //       // ),
          //     ],
          //   ),
          // ),
          // floatingActionButton: FloatingActionButton(
          //   child: Icon(Icons.add),
          //   onPressed: addItem,
          // ),
        ),
      ),
    );
  }
}
