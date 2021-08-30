import 'dart:convert';

import 'package:contact_tracing/classes/globals.dart';
import 'package:contact_tracing/pages/register.dart';
import 'package:contact_tracing/pages/splash.dart';
import 'package:contact_tracing/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  static const String route = '/login';

  @override
  _LoginState createState() {
    return _LoginState();
  }
}

// Used for controlling whether the user is loggin or creating an account
enum FormType { login, register }

class _LoginState extends State<LoginPage> {
  String msgError = "";

  TextEditingController _username = TextEditingController();
  TextEditingController _password = TextEditingController();

  // our default setting is to login, and we should switch to creating an account when the user chooses to
  FormType _form = FormType.login;

  // Swap in between our two forms, registering and logging in
  Future<void> _formChange() async {
    setState(() {
      if (_form == FormType.register) {
        _form = FormType.login;
      } else {
        _form = FormType.register;
      }
    });
  }

  Future<void> _loginPressed() async {
    final res = await http.post(Uri.parse(loginUrl),
        body: {"username": _username.text, "password": _password.text});
    final data = jsonDecode(res.body);

    if (data['msg'] == "data does not exist") {
      msgError = "Wrong Credentials!";
      _username.clear();
      _password.clear();
      setState(() {});
    } else {
      msgError = ""; //"User logged in";
      setState(
        () async {
          //redirect to home
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('username', _username.text);
          await prefs.setString('password', _password.text);
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (ctx) => SplashPage()));
        },
      );
    }
  }

  void _createAccountPressed() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => RegisterPage()));
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
    if (_form == FormType.login) {
      return new Container(
        child: new Column(
          children: <Widget>[
            new ElevatedButton(
              child: new Text('Login'),
              onPressed: _loginPressed,
            ),
            new TextButton(
              child: new Text('Dont have an account? Tap here to register.'),
              onPressed: _formChange,
            ),
            new TextButton(
              child: new Text('Forgot Password?'),
              onPressed: _passwordReset,
            )
          ],
        ),
      );
    } else {
      return new Container(
        child: new Column(
          children: <Widget>[
            new ElevatedButton(
              child: new Text('Create an Account'),
              onPressed: _createAccountPressed,
            ),
            new TextButton(
              child: new Text('Have an account? Click here to login.'),
              onPressed: _formChange,
            ),
            new TextButton(
              child: new Text('Have an account? Click here to login.'),
              onPressed: _formChange,
            )
          ],
        ),
      );
    }
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
          body: Container(
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: ListView(
                children: <Widget>[
                  _buildTextFields(),
                  _buildButtons(),
                  Center(
                    child: Text(
                      msgError,
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
