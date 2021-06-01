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

  insertApi(firstname, lastname, country, address, telephone, email,
      dateOfBirth, nationalIdNumber, username, password) async {
    final res = await http.post(
      Uri.parse(registerUrl),
      body: {
        'firstName': firstname,
        'lastName': lastname,
        'country': country,
        'address': address,
        'telephone': telephone,
        'email': email,
        'dateOfBirth': dateOfBirth,
        'nationalIdNumber': nationalIdNumber,
        'username': username,
        'password': password
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
      prefs.setString('firstName', firstname);
      prefs.setString('lastName', lastname);
      prefs.setString('country', country);
      prefs.setString('address', address);
      prefs.setString('telephone', telephone);
      prefs.setString('email', email);
      prefs.setString('dateOfBirth', dateOfBirth);
      prefs.setString('nationalIdNumber', nationalIdNumber);
      prefs.setString('username', username);
      prefs.setString('password', password);
      prefs.setString("userId", data['userId']);
    }
    _firstName.clear();
    _lastName.clear();
    _country.clear();
    _address.clear();
    _telephone.clear();
    _email.clear();
    _dateOfBirth.clear();
    _nationalIdNumber.clear();
    _username.clear();
    _password.clear();
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
                      controller: _firstName,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: "Firstname",
                        hintText: "Firstname",
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
                      controller: _lastName,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: "Lastname",
                        hintText: "Lastname",
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
                      controller: _country,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: "Country",
                        hintText: "Country",
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
                      controller: _address,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: "Address",
                        hintText: "Address",
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
                      controller: _telephone,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: "Telephone",
                        hintText: "Telephone",
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
                      controller: _email,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: "Email",
                        hintText: "Email",
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
                      controller: _dateOfBirth,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: "DOB",
                        hintText: "DOB",
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
                      controller: _nationalIdNumber,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: "NIC",
                        hintText: "NIC",
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
                      controller: _username,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: "username",
                        hintText: "username",
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
                    color: Colors.pink,
                    child: MaterialButton(
                      onPressed: () {
                        insertApi(
                          _firstName.text,
                          _lastName.text,
                          _country.text,
                          _address.text,
                          _telephone.text,
                          _email.text,
                          _dateOfBirth.text,
                          _nationalIdNumber.text,
                          _username.text,
                          _password.text,
                        );
                      },
                      color: Colors.pink,
                      child: Text("REGISTER"),
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
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
