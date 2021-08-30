import 'package:contact_tracing/pages/login.dart';
import 'package:contact_tracing/pages/splash.dart';
import 'package:contact_tracing/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../classes/globals.dart';
import 'dart:convert';

class RegisterPage extends StatefulWidget {
  static const String route = '/register';

  @override
  _RegisterPageState createState() {
    return _RegisterPageState();
  }
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController _firstName = TextEditingController();
  TextEditingController _lastName = TextEditingController();
  TextEditingController _country = TextEditingController();
  TextEditingController _address = TextEditingController();
  TextEditingController _telephone = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _dateOfBirth = TextEditingController();
  TextEditingController _nationalIdNumber = TextEditingController();
  TextEditingController _username = TextEditingController();
  TextEditingController _password = TextEditingController();

  String msg = "";

  //static const items = <String>["admin", "user"];

  // List<DropdownMenuItem<String>> _myitems = items
  //     .map((e) => DropdownMenuItem(
  //           value: e,
  //           child: Text(e),
  //         ))
  //     .toList();

  //String valueItem = "admin";

  Future<void> _loginPressed() async {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => LoginPage()));
  }

  Future<void> _registerPressed() async {
    final res = await http.post(
      Uri.parse(registerUrl),
      body: {
        'firstName': _firstName.text,
        'lastName': _lastName.text,
        'country': _country.text,
        'address': _address.text,
        'telephone': _telephone.text,
        'email': _email.text,
        'dateOfBirth': _dateOfBirth.text,
        'nationalIdNumber': _nationalIdNumber.text,
        'username': _username.text,
        'password': _password.text
      },
    );
    //print(res.body);
    final data = jsonDecode(res.body);

    if (data['msg'] == 'username already existed') {
      msg = 'username already existed';
      print(msg);
    } else {
      //user inserted
      //redirect to home
      print('user inserted');
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('firstName', _firstName.text);
      await prefs.setString('lastName', _lastName.text);
      await prefs.setString('country', _country.text);
      await prefs.setString('address', _address.text);
      await prefs.setString('telephone', _telephone.text);
      await prefs.setString('email', _email.text);
      await prefs.setString('dateOfBirth', _dateOfBirth.text);
      await prefs.setString('nationalIdNumber', _nationalIdNumber.text);
      await prefs.setString('username', _username.text);
      await prefs.setString('password', _password.text);
      await prefs.setString("userId", data['userId'].toString());
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (ctx) => SplashPage()));
    }
    // _firstName.clear();
    // _lastName.clear();
    // _country.clear();
    // _address.clear();
    // _telephone.clear();
    // _email.clear();
    // _dateOfBirth.clear();
    // _nationalIdNumber.clear();
    // _username.clear();
    // _password.clear();
    // if (dataJson['status'] == 1) {
    //   print(dataJson['msg']);
    //   showDialog(
    //     context: context,
    //     builder: (c) {
    //       return AlertDialog(
    //         title: Text("Notifikasi"),
    //         content: Text(dataJson['msg']),
    //         actions: <Widget>[
    //           TextButton(
    //             onPressed: () {
    //               Navigator.of(context).pop();
    //             },
    //             child: Text("Close"),
    //           )
    //         ],
    //       );
    //     },
    //   );
    //   setState(
    //     () {
    //       msg = dataJson['msg'];
    //     },
    //   );
    // } else if (dataJson['status'] == 2) {
    //   print(dataJson['msg']);
    //   Navigator.of(context).pop();
    //   setState(
    //     () {
    //       msg = "";
    //     },
    //   );
    // } else {
    //   print(dataJson['msg']);
    //   setState(
    //     () {
    //       msg = dataJson['msg'];
    //     },
    //   );
    // }
  }

  Widget _buildTextFields() {
    return new Container(
      child: new Column(
        children: <Widget>[
          new Container(
            child: TextField(
              controller: _firstName,
              decoration: new InputDecoration(labelText: 'First Name'),
              // decoration: InputDecoration(
              //   border: InputBorder.none,
              //   labelText: "Firstname",
              //   hintText: "Firstname",
              // ),
            ),
          ),
          // SizedBox(
          //   height: 20.0,
          // ),
          new Container(
            // alignment: Alignment.center,
            // padding: EdgeInsets.all(10.0),
            // decoration: BoxDecoration(
            //   gradient: LinearGradient(
            //     colors: [Colors.white, Colors.grey],
            //   ),
            //   borderRadius: BorderRadius.circular(20.0),
            // ),
            child: TextField(
              controller: _lastName,
              decoration: new InputDecoration(labelText: 'Last Name'),
            ),
          ),
          // SizedBox(
          //   height: 20.0,
          // ),
          Container(
            // alignment: Alignment.center,
            // padding: EdgeInsets.all(10.0),
            // decoration: BoxDecoration(
            //   gradient: LinearGradient(
            //     colors: [Colors.white, Colors.grey],
            //   ),
            //   borderRadius: BorderRadius.circular(20.0),
            // ),
            child: TextField(
              controller: _country,
              decoration: new InputDecoration(labelText: 'Country'),
              // decoration: InputDecoration(
              //   border: InputBorder.none,
              //   labelText: "Country",
              //   hintText: "Country",
              // ),
            ),
          ),
          // SizedBox(
          //   height: 20.0,
          // ),
          new Container(
            // alignment: Alignment.center,
            // padding: EdgeInsets.all(10.0),
            // decoration: BoxDecoration(
            //   gradient: LinearGradient(
            //     colors: [Colors.white, Colors.grey],
            //   ),
            //   borderRadius: BorderRadius.circular(20.0),
            // ),
            child: TextField(
              controller: _address,
              decoration: new InputDecoration(labelText: 'Address'),
            ),
          ),
          // SizedBox(
          //   height: 20.0,
          // ),
          new Container(
            // alignment: Alignment.center,
            // padding: EdgeInsets.all(10.0),
            // decoration: BoxDecoration(
            //   gradient: LinearGradient(
            //     colors: [Colors.white, Colors.grey],
            //   ),
            //   borderRadius: BorderRadius.circular(20.0),
            // ),
            child: TextField(
              controller: _telephone,
              decoration: new InputDecoration(labelText: 'Telephone'),
              // decoration: InputDecoration(
              //   border: InputBorder.none,
              //   labelText: "Telephone",
              //   hintText: "Telephone",
              // ),
            ),
          ),
          // SizedBox(
          //   height: 20.0,
          // ),
          new Container(
            // alignment: Alignment.center,
            // padding: EdgeInsets.all(10.0),
            // decoration: BoxDecoration(
            //   gradient: LinearGradient(
            //     colors: [Colors.white, Colors.grey],
            //   ),
            //   borderRadius: BorderRadius.circular(20.0),
            // ),
            child: TextField(
              controller: _email,
              decoration: new InputDecoration(labelText: 'Email'),
              // decoration: InputDecoration(
              //   border: InputBorder.none,
              //   labelText: "Email",
              //   hintText: "Email",
              // ),
            ),
          ),
          // SizedBox(
          //   height: 20.0,
          // ),
          new Container(
            // alignment: Alignment.center,
            // padding: EdgeInsets.all(10.0),
            // decoration: BoxDecoration(
            //   gradient: LinearGradient(
            //     colors: [Colors.white, Colors.grey],
            //   ),
            //   borderRadius: BorderRadius.circular(20.0),
            // ),
            child: TextField(
              controller: _dateOfBirth,
              decoration: new InputDecoration(labelText: 'Date of Birth'),
              // decoration: InputDecoration(
              //   border: InputBorder.none,
              //   labelText: "DOB",
              //   hintText: "DOB",
              // ),
            ),
          ),
          // SizedBox(
          //   height: 20.0,
          // ),
          new Container(
            // alignment: Alignment.center,
            // padding: EdgeInsets.all(10.0),
            // decoration: BoxDecoration(
            //   gradient: LinearGradient(
            //     colors: [Colors.white, Colors.grey],
            //   ),
            //   borderRadius: BorderRadius.circular(20.0),
            // ),
            child: TextField(
              controller: _nationalIdNumber,
              decoration: new InputDecoration(labelText: 'NIC'),
              // decoration: InputDecoration(
              //   border: InputBorder.none,
              //   labelText: "NIC",
              //   hintText: "NIC",
              // ),
            ),
          ),
          // SizedBox(
          //   height: 20.0,
          // ),
          new Container(
            // alignment: Alignment.center,
            // padding: EdgeInsets.all(10.0),
            // decoration: BoxDecoration(
            //   gradient: LinearGradient(
            //     colors: [Colors.white, Colors.grey],
            //   ),
            //   borderRadius: BorderRadius.circular(20.0),
            // ),
            child: TextField(
              controller: _username,
              decoration: new InputDecoration(labelText: 'Username'),
              // decoration: InputDecoration(
              //   border: InputBorder.none,
              //   labelText: "username",
              //   hintText: "username",
              // ),
            ),
          ),
          // SizedBox(
          //   height: 20.0,
          // ),
          new Container(
            // alignment: Alignment.center,
            // padding: EdgeInsets.all(10.0),
            // decoration: BoxDecoration(
            //   gradient: LinearGradient(
            //     colors: [Colors.white, Colors.grey],
            //   ),
            //   borderRadius: BorderRadius.circular(20.0),
            // ),
            child: TextField(
              controller: _password,
              obscureText: true,
              decoration: new InputDecoration(labelText: 'Password'),
              // decoration: InputDecoration(
              //   border: InputBorder.none,
              //   labelText: "Password",
              //   hintText: "Password",
              // ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtons() {
    return new Container(
      child: new Column(
        children: <Widget>[
          new ElevatedButton(
            child: new Text('Register'),
            onPressed: _registerPressed,
          ),
          new TextButton(
            child: new Text('Already have an account? Tap here to login.'),
            onPressed: _loginPressed,
          ),
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
            title: Text("Register"),
            centerTitle: true,
            backgroundColor: Colors.blue,
          ),
          drawer: buildDrawer(context, RegisterPage.route),
          body: Container(
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: ListView(
                children: <Widget>[
                  _buildTextFields(),
                  _buildButtons(),
                  //Container(
                  // alignment: Alignment.center,
                  // padding: EdgeInsets.all(10.0),
                  // decoration: BoxDecoration(
                  //   gradient: LinearGradient(
                  //     colors: [Colors.white, Colors.grey],
                  //   ),
                  //   borderRadius: BorderRadius.circular(20.0),
                  // ),
                  // ),
                  // SizedBox(
                  //   height: 20.0,
                  // ),
                  // Material(
                  //   borderRadius: BorderRadius.circular(20.0),
                  //   elevation: 10.0,
                  //   color: Colors.pink,
                  //   child: MaterialButton(
                  //     onPressed: () {
                  //       insertApi(
                  //         _firstName.text,
                  //         _lastName.text,
                  //         _country.text,
                  //         _address.text,
                  //         _telephone.text,
                  //         _email.text,
                  //         _dateOfBirth.text,
                  //         _nationalIdNumber.text,
                  //         _username.text,
                  //         _password.text,
                  //       );
                  //     },
                  //     color: Colors.pink,
                  //     child: Text("REGISTER"),
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: 15.0,
                  // ),
                  Center(
                    child: Text(
                      msg,
                      style: TextStyle(color: Colors.red),
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
