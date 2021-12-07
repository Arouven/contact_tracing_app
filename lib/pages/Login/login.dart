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
  final username;
  final password;
  const LoginPage({
    this.username,
    this.password,
  });

  @override
  _LoginState createState() {
    print("in login");
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
      print(username);
      print(password);
      final res = await http.post(Uri.parse(loginUrl), body: {
        "username": username,
        "password": password,
      });
      print("urlparse");
      final data = jsonDecode(res.body);
      print(data);
      print("jsondecode");

      if (data['msg'] == "data does not exist") {
        print(data['msg']);
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
        print(data['msg']);
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', username);
        await prefs.setString('password', password);
        await prefs.setBool('justLogin', true);
        print("credential save");
        setState(() {
          _isLoading = false;
        });
        print("mobileid is " + prefs.getString('mobileId').toString());
        if (prefs.getString('mobileId') == '' ||
            prefs.getString('mobileId') == null) {
          print("mobile id is null");
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => MobilePage()),
              (e) => false);
        } else {
          print("mobile id is not null");
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => LiveGeolocatorPage()),
              (e) => false);
        }
      }
    } catch (e) {
      print("exception in login");
      print(e);
      setState(() {
        _isLoading = false;
        _showReload = true;
      });
    }
    //redirect to home
  }

  void _createAccountPressed() {
    print("_createAccountPressed function");
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => RegisterPage()));
  }

  void _passwordReset() {
    print("_passwordReset function");
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
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => LoginPage(
                        username: _username.text.trim(),
                        password: _password.text.trim())),
                (e) => false);
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
              child: new Text("Don\'t have an account? Tap here to register."),
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
  void initState() {
    // _username.text = widget.username!.toString();
    //_password.text = widget.password!.toString();
    _username.text =
        ((widget.username != null) ? widget.username.toString() : '');
    _password.text =
        ((widget.password != null) ? widget.password.toString() : '');
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

  @override
  void dispose() {
    _password.dispose();
    _username.dispose();
    super.dispose();
  }
}
