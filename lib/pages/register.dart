import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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

  insertApi() async {
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
        'password': _password.text,
      },
    );

    final dataJson = jsonDecode(res.body);

    _firstName.clear();
    _lastName.clear();
    _country.clear();
    _address.clear();
    _telephone.clear();
    _email.clear();
    _dateOfBirth.clear();
    _nationalIdNumber.clear();

    if (dataJson['status'] == 1) {
      print(dataJson['msg']);
      showDialog(
        context: context,
        builder: (c) {
          return AlertDialog(
            title: Text("Notifikasi"),
            content: Text(dataJson['msg']),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Close"),
              )
            ],
          );
        },
      );
      setState(
        () {
          msg = dataJson['msg'];
        },
      );
    } else if (dataJson['status'] == 2) {
      print(dataJson['msg']);
      Navigator.of(context).pop();
      setState(
        () {
          msg = "";
        },
      );
    } else {
      print(dataJson['msg']);
      setState(
        () {
          msg = dataJson['msg'];
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
        backgroundColor: Colors.pink,
      ),
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
                    colors: [Colors.amber, Colors.pink],
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
                    colors: [Colors.amber, Colors.pink],
                  ),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: TextField(
                  controller: _lastName,
                  obscureText: true,
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
                    colors: [Colors.amber, Colors.pink],
                  ),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: TextField(
                  controller: _country,
                  obscureText: true,
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
                    colors: [Colors.amber, Colors.pink],
                  ),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: TextField(
                  controller: _address,
                  obscureText: true,
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
                    colors: [Colors.amber, Colors.pink],
                  ),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: TextField(
                  controller: _telephone,
                  obscureText: true,
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
                    colors: [Colors.amber, Colors.pink],
                  ),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: TextField(
                  controller: _email,
                  obscureText: true,
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
                    colors: [Colors.amber, Colors.pink],
                  ),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: TextField(
                  controller: _dateOfBirth,
                  obscureText: true,
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
                    colors: [Colors.amber, Colors.pink],
                  ),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: TextField(
                  controller: _nationalIdNumber,
                  obscureText: true,
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
                    colors: [Colors.amber, Colors.pink],
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
                    insertApi();
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
    );
  }
}
