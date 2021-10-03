import 'dart:convert';

import 'package:contact_tracing/classes/globals.dart';
import 'package:contact_tracing/pages/Location/live_geolocator.dart';
import 'package:contact_tracing/pages/Login/register.dart';
import 'package:contact_tracing/pages/Mobile/mobiles.dart';
import 'package:contact_tracing/pages/splash.dart';
import 'package:contact_tracing/widgets/commonWidgets.dart';
import 'package:contact_tracing/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

//import 'dotindicator.dart';

class LoginPage extends StatefulWidget {
  static const String route = '/login';

  @override
  _LoginState createState() {
    return _LoginState();
  }
}

class _LoginState extends State<LoginPage> {
  bool _isLoading = false;
  bool _showReload = false;

  TextEditingController _username = TextEditingController();
  TextEditingController _password = TextEditingController();

  void _loginPressed() async {
    setState(() {
      _isLoading = true;
    });
    String username = _username.text.trim();
    String password = _password.text.trim();
    try {
      final res = await http.post(Uri.parse(loginUrl), body: {
        "username": username,
        "password": password,
      });
      final data = jsonDecode(res.body);

      if (data['msg'] == "data does not exist") {
        print("Wrong Credentials!");
        setState(() {
          _isLoading = false;
        });
        DialogBox.showErrorDialog(
          context: context,
          title: 'Wrong Credentials!',
          body:
              'Your credentials are not found in our database. Please register or insert correct credentials',
        );
      } else {
        //"User logged in";
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', username);
        await prefs.setString('password', password);
        setState(() {
          _isLoading = false;
        });
        if (prefs.getString('mobileId') != '' ||
            prefs.getString('mobileId') != null) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => LiveGeolocatorPage()),
              (e) => false);
        } else {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => MobilePage()),
              (e) => false);
        }
      }
    } on Exception {
      setState(() {
        _isLoading = false;
        _showReload = true;
      });
    }
    //redirect to home
  }

  void _createAccountPressed() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => RegisterPage()));
  }

  void _passwordReset() {
    // print("The user wants a password reset request sent to $_email");
  }

  Widget _body() {
    if (_isLoading == true) {
      return Aesthetic.displayCircle();
    } else if (_showReload == true) {
      return Center(
        child: FloatingActionButton(
          foregroundColor: Colors.red,
          backgroundColor: Colors.white,
          child: Icon(Icons.replay),
          onPressed: () {
            _loginPressed();
          },
        ),
      );
    } else {
      return _displayLogin();
    }
  }

  Widget _displayLogin() {
    return Container(
      child: ListView(
        shrinkWrap: true,
        physics: AlwaysScrollableScrollPhysics(),
        children: <Widget>[
          ListTile(
            title: new TextField(
              controller: _username,
              decoration: new InputDecoration(labelText: 'Username'),
            ),
          ),
          ListTile(
            title: new TextField(
              controller: _password,
              decoration: new InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
          ),
          ListTile(
            title: new TextButton(
              child: new Text('Dont have an account? Tap here to register.'),
              onPressed: _createAccountPressed,
            ),
          ),
          ListTile(
            title: new TextButton(
              child: new Text('Forgot Password?'),
              onPressed: _passwordReset,
            ),
          ),
          ListTile(
            title: new ElevatedButton(
              child: new Text('Login'),
              onPressed: () {
                _loginPressed();
              },
            ),
          ),
        ],
      ),
    );
  }

  // Widget displayCircle() {
  //   return Container(
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       children: [
  //         SizedBox(
  //           height: MediaQuery.of(context).size.height / 1.3,
  //           child: Center(
  //             child: CircularProgressIndicator(),
  //           ),
  //         ),
  //         // Padding(
  //         //   //padding: EdgeInsets.only(top: 16),
  //         //   child:
  //         Text('Awaiting result...'),
  //         // )
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        top: true,
        bottom: true,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text("Login"),
            backgroundColor: Colors.blue,
          ),
          drawer: buildDrawer(context, LoginPage.route),
          body: _body(),
        ),
      ),
    );
  }
}
