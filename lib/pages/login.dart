import 'dart:convert';

import 'package:contact_tracing/classes/globals.dart';
import 'package:contact_tracing/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//import '../pages/register.dart';

class LoginPage extends StatefulWidget {
  static const String route = '/login';

  @override
  _LoginState createState() {
    return _LoginState();
  }
}

class _LoginState extends State<LoginPage> {
  String msgError = "";

  getApi(String username, String password) async {
    final res = await http.post(Uri.parse(loginUrl),
        body: {"username": username, "password": password});
    final data = jsonDecode(res.body);

    if (data['msg'] == "data does not exist") {
      print(data['msg']);
      msgError = "User does not exist or wrong password!";
      _username.clear();
      _password.clear();
      setState(
        () {
          //register btn appear
        },
      );
    } else {
      print(data['msg']);
      msgError = ""; //"User logged in";
      _username.clear();
      _password.clear();
      setState(
        () {
          //redirect to home
        },
      );
    }
  }

  TextEditingController _username = TextEditingController();
  TextEditingController _password = TextEditingController();

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
            // elevation: 0.5,
            // actions: <Widget>[
            //   TextButton(
            //     onPressed: () {
            //       Navigator.of(context).push(
            //         MaterialPageRoute(
            //           builder: (context) => RegisterPage(),
            //         ),
            //       );
            //     },
            //     child: Text("Register"),

            //   )
            // ],
          ),
          drawer: buildDrawer(context, LoginPage.route),
          body: Container(
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: ListView(
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.white, Colors.grey],
                      ),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: TextField(
                      controller: _username,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: "Username",
                        hintText: "Username",
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.white, Colors.grey],
                      ),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: TextField(
                      controller: _password,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: "Password",
                        hintText: "Password",
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Material(
                    borderRadius: BorderRadius.circular(20.0),
                    elevation: 10.0,
                    color: Colors.blue,
                    child: MaterialButton(
                      onPressed: () {
                        getApi(
                          _username.text,
                          _password.text,
                        );
                      },
                      //color: Colors.blue,
                      child: Text("LOGIN"),
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
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
