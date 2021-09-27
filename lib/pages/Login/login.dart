import 'dart:convert';

import 'package:contact_tracing/classes/globals.dart';
import 'package:contact_tracing/pages/Login/register.dart';
import 'package:contact_tracing/pages/splash.dart';
import 'package:contact_tracing/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'dotindicator.dart';

class LoginPage extends StatefulWidget {
  static const String route = '/login';

  @override
  _LoginState createState() {
    return _LoginState();
  }
}

// Used for controlling whether the user is loggin or creating an account
//enum FormType { login, register }

class _LoginState extends State<LoginPage> {
  bool _isLoading = false;
  //bool _displayError = false;
  String _msgError = "";

  TextEditingController _username = TextEditingController();
  TextEditingController _password = TextEditingController();

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Wrong Credentials',
            style: TextStyle(
              color: Colors.red,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                new Row(
                  children: [
                    Icon(
                      Icons.cancel,
                      color: Colors.red,
                    ),
                    Expanded(
                      child: Text(_msgError),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _loginPressed() async {
    setState(() {
      _isLoading = true;
    });
    final res = await http.post(Uri.parse(loginUrl),
        body: {"username": _username.text, "password": _password.text});
    final data = jsonDecode(res.body);
    //_displayError = false;
    if (data['msg'] == "data does not exist") {
      //_displayError = true;
      _msgError = "Wrong Credentials!";
      _username.clear();
      _password.clear();
      setState(() {
        _isLoading = false;
        _showMyDialog();
      });
    } else {
      _msgError = ""; //"User logged in";
      setState(() async {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', _username.text);
        await prefs.setString('password', _password.text);
        _isLoading = false;
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => SplashPage()),
            (e) => false);
      });
      //redirect to home

    }
  }

  void _createAccountPressed() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => RegisterPage()));
  }

  void _passwordReset() {
    // print("The user wants a password reset request sent to $_email");
  }
  Widget _buildTextFields() {
    return new Container(
      child: new Column(
        children: <Widget>[
          new Container(
            child: new TextField(
              controller: _username,
              decoration: new InputDecoration(labelText: 'Username'),
            ),
          ),
          new Container(
            child: new TextField(
              controller: _password,
              decoration: new InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildButtons() {
    return new Container(
      child: new Column(
        children: <Widget>[
          new ElevatedButton(
            child: new Text('Login'),
            onPressed: () {
              _isLoading = true;

              _loginPressed();
            },
          ),
          new TextButton(
            child: new Text('Dont have an account? Tap here to register.'),
            onPressed: _createAccountPressed,
          ),
          new TextButton(
            child: new Text('Forgot Password?'),
            onPressed: _passwordReset,
          )
        ],
      ),
    );
  }

  Widget displayLogin() {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Center(
        child: ListView(
          children: <Widget>[
            _buildTextFields(),
            _buildButtons(),
            Center(
              child: Text(
                _msgError,
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
          body: _isLoading ? displayCircle() : displayLogin(),
        ),
      ),
    );
  }
}
