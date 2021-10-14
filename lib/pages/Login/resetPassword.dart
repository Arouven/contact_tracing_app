import 'dart:convert';

import 'package:contact_tracing/classes/globals.dart';
import 'package:contact_tracing/widgets/commonWidgets.dart';
import 'package:contact_tracing/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';

//import 'dotindicator.dart';

class ResetPage extends StatefulWidget {
  static const String route = '/reset';

  @override
  _ResetState createState() {
    return _ResetState();
  }
}

class _ResetState extends State<ResetPage> {
  bool _isLoading = false;
  bool _showReload = false;

  TextEditingController _username = TextEditingController();

  Future<void> _passwordResetPressed() async {
    setState(() {
      _isLoading = true;
    });
    String username = _username.text.trim();
    try {
      final res =
          await http.post(Uri.parse(resetUrl), body: {"username": username});
      final data = jsonDecode(res.body);

      if (data['msg'] == "data does not exist") {
        print("Wrong Credentials!");
        setState(() {
          _isLoading = false;
        });
        DialogBox.showErrorDialog(
          context: context,
          title: 'Username Does Not Exist',
          body:
              'Your username is not found in our database. Please register or insert correct username',
        );
      } else {
        //"User logged in";
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', username);
        setState(() {
          _isLoading = false;
        });
        DialogBox.showDiscardDialog(
          context: context,
          title: 'Password Reset',
          body: data['msg'],
          buttonText: 'Ok',
          titleColor: Colors.orange,
          route: LoginPage(),
        );
      }
    } on Exception {
      setState(() {
        _isLoading = false;
        _showReload = true;
      });
    }
    //redirect to home
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
            _passwordResetPressed();
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
            title: new ElevatedButton(
              child: new Text('Reset'),
              onPressed: () {
                _passwordResetPressed();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _backButton() {
    return IconButton(
      icon: Icon(
        Icons.arrow_back,
        color: Colors.white,
      ),
      onPressed: () {
        DialogBox.showDiscardDialog(
          context: context,
          title: 'Back to Login',
          body: 'Are you sure you want to go back to Login?',
          buttonText: 'Back',
          route: LoginPage(),
        );
      },
    );
  }

  Widget _appBar() {
    return AppBar(
      automaticallyImplyLeading: true,
      leading: _backButton(),
      centerTitle: true,
      title: Text("Reset Password"),
      backgroundColor: Colors.blue,
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
          appBar: _appBar(),
          drawer: buildDrawer(context, ResetPage.route),
          body: _body(),
        ),
      ),
    );
  }
}
