// import 'package:contact_tracing/pages/Login/login.dart';
// import 'package:contact_tracing/pages/splash.dart';
// import 'package:contact_tracing/widgets/drawer.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
// import '../../classes/globals.dart';
// import 'dart:convert';

// class RegisterPage extends StatefulWidget {
//   static const String route = '/register';

//   @override
//   _RegisterPageState createState() {
//     return _RegisterPageState();
//   }
// }

// class _RegisterPageState extends State<RegisterPage> {
//   TextEditingController _firstName = TextEditingController();
//   TextEditingController _lastName = TextEditingController();
//   TextEditingController _country = TextEditingController();
//   TextEditingController _address = TextEditingController();
//   TextEditingController _email = TextEditingController();
//   var _dateOfBirth;
//   TextEditingController _nationalIdNumber = TextEditingController();
//   TextEditingController _username = TextEditingController();
//   TextEditingController _password = TextEditingController();

//   String msg = "";
//   var _dateParse;
//   @override
//   void initState() {
//     var date = new DateTime.now().toString();

//     setState(() {
//       _dateParse = DateTime.parse(date);
//     });
//     super.initState();
//   }

//   Future<void> _loginPressed() async {
//     Navigator.of(context)
//         .pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
//   }

//   Future<void> _registerPressed() async {
//     final res = await http.post(
//       Uri.parse(registerUrl),
//       body: {
//         'firstName': _firstName.text,
//         'lastName': _lastName.text,
//         'country': _country.text,
//         'address': _address.text,
//         'email': _email.text,
//         'dateOfBirth': _dateOfBirth.text,
//         'nationalIdNumber': _nationalIdNumber.text,
//         'username': _username.text,
//         'password': _password.text
//       },
//     );
//     //print(res.body);
//     final data = jsonDecode(res.body);

//     if (data['msg'] == 'username already existed') {
//       msg = 'username already existed';
//       print(msg);
//     } else {
//       //user inserted
//       //redirect to home
//       print('user inserted');
//       final SharedPreferences prefs = await SharedPreferences.getInstance();

//       await prefs.setString('username', _username.text);
//       await prefs.setString('password', _password.text);

//       Navigator.of(context).pushReplacement(
//           MaterialPageRoute(builder: (context) => SplashPage()));
//     }
//   }

//   Widget _buildTextFields() {
//     return new Container(
//       child: new Column(
//         children: <Widget>[
//           new Container(
//             child: TextField(
//               controller: _firstName,
//               decoration: new InputDecoration(labelText: 'First Name'),
//             ),
//           ),
//           new Container(
//             child: TextField(
//               controller: _lastName,
//               decoration: new InputDecoration(labelText: 'Last Name'),
//             ),
//           ),
//           Container(
//             child: TextField(
//               controller: _country,
//               decoration: new InputDecoration(labelText: 'Country'),
//             ),
//           ),
//           new Container(
//             child: TextField(
//               controller: _address,
//               decoration: new InputDecoration(labelText: 'Address'),
//             ),
//           ),
//           new Container(
//             child: TextField(
//               controller: _email,
//               decoration: new InputDecoration(labelText: 'Email'),
//             ),
//           ),
//           new Container(
//             child: new DatePickerWidget(
//               looping: true, // default is not looping
//               //firstDate: DateTime(_dateParse.year-18, 01, 01),
//               lastDate:
//                   DateTime(_dateParse.year, _dateParse.month, _dateParse.day),

//               initialDate: DateTime(_dateParse.year - 18, 01, 01),
//               dateFormat: "dd-MMM-yyyy",
//               locale: DatePicker.localeFromString('en'),
//               onChange: (DateTime newDate, _) {
//                 _dateOfBirth = newDate;
//                 print(_dateOfBirth);
//               },
//               pickerTheme: DateTimePickerTheme(
//                 itemTextStyle: TextStyle(color: Colors.black, fontSize: 19),
//                 dividerColor: Colors.blue,
//               ),
//             ),
//           ),
//           new Container(
//             child: TextField(
//               controller: _nationalIdNumber,
//               decoration: new InputDecoration(labelText: 'NIC'),
//             ),
//           ),
//           new Container(
//             child: TextField(
//               controller: _username,
//               decoration: new InputDecoration(labelText: 'Username'),
//             ),
//           ),
//           new Container(
//             child: TextField(
//               controller: _password,
//               obscureText: true,
//               decoration: new InputDecoration(labelText: 'Password'),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildButtons() {
//     return new Container(
//       child: new Column(
//         children: <Widget>[
//           new ElevatedButton(
//             child: new Text('Register'),
//             onPressed: _registerPressed,
//           ),
//           new TextButton(
//             child: new Text('Already have an account? Tap here to login.'),
//             onPressed: _loginPressed,
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.white,
//       child: SafeArea(
//         top: true,
//         bottom: true,
//         child: Scaffold(
//           appBar: AppBar(
//             title: Text("Register"),
//             centerTitle: true,
//             backgroundColor: Colors.blue,
//           ),
//           drawer: buildDrawer(context, RegisterPage.route),
//           body: Container(
//             padding: EdgeInsets.all(10.0),
//             child: Center(
//               child: ListView(
//                 children: <Widget>[
//                   _buildTextFields(),
//                   _buildButtons(),
//                   Center(
//                     child: Text(
//                       msg,
//                       style: TextStyle(color: Colors.red),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
