import 'package:contact_tracing/pages/Location/live_geolocator.dart';
import 'package:contact_tracing/pages/Login/register.dart';
import 'package:contact_tracing/pages/Mobile/mobiles.dart';
import 'package:contact_tracing/services/auth.dart';
import 'package:contact_tracing/services/globals.dart';
import 'package:contact_tracing/services/notification.dart';
import 'package:contact_tracing/widgets/commonWidgets.dart';
import 'package:contact_tracing/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';

class LoginPage extends StatefulWidget {
  static const String route = '/login';
  final email;
  final password;
  const LoginPage({
    this.email,
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

  late var _subscription;
  bool _internetConnection = true;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  bool _invalidPassword = false;
  bool _invalidemail = false;

  bool _obscureText = true;

  void _loginPressed() async {
    setState(() {
      _isLoading = true;
    });
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    if (_passwordController.text.isEmpty == true) {
      setState(() {
        _invalidPassword = true;
        _isLoading = false;
      });
    }
    if (_emailController.text.isEmpty == true) {
      setState(() {
        _invalidemail = true;
        _isLoading = false;
      });
    }
    if ((_emailController.text.isEmpty == false) &&
        (_passwordController.text.isEmpty == false)) {
      try {
        bool firebaseLoggedIn = await FirebaseAuthenticate().firebaseLoginUser(
          email: email,
          password: password,
        );
        if (firebaseLoggedIn == true) {
          print(email);
          print(password);
          await GlobalVariables.setEmail(email: email);
          await GlobalVariables.setJustLogin(justLogin: true);
          final mobileNumber = await GlobalVariables.getMobileNumber();

          print("credential save");
          //print("mobileNumber is " + mobileNumber);
          if (mobileNumber == '' || mobileNumber == null) {
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
        } else {
          //firebase login fail
          setState(() {
            _isLoading = false;
          });
          DialogBox.showErrorDialog(
            context: context,
            title: FirebaseAuthenticate().geterrors().code,
            body: FirebaseAuthenticate().geterrors().message!,
          );
        }
      } catch (e) {
        print("exception in login");
        print(e);
        setState(() {
          _isLoading = false;
          _showReload = true;
        });
      }
    }

    //redirect to home
  }

  _checkEmail(String email) async {
    // Null or empty string is invalid
    if (email == null || email.isEmpty) {
      return false;
    }
    const pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    final regExp = RegExp(pattern);
    if (!regExp.hasMatch(email)) {
      //not good mail
      return false;
    } else {
      //good mail
      bool? emailExist = await FirebaseAuthenticate().emailExist(
        email: email,
      );
      if (emailExist != null) {
        return emailExist;
      }
      return false;
    }
  }

  Future<void> _passwordReset() async {
    final email = _emailController.text.trim();
    bool isEmailGood = await _checkEmail(email);

    print("_passwordReset function");
    if (isEmailGood == true) {
      bool isReset = await FirebaseAuthenticate().firebaseResetPassword(
        email: email,
      );
      if (isReset == true) {
        DialogBox.showErrorDialog(
          context: context,
          title: 'Password Reset',
          body: 'Please verify your email for password new password!',
          titleColor: Colors.green,
        );
      } else {
        DialogBox.showErrorDialog(
          context: context,
          title: FirebaseAuthenticate().geterrors().code,
          body: FirebaseAuthenticate().geterrors().message!,
        );
      }
    } else {
      DialogBox.showErrorDialog(
        context: context,
        title: 'Wrong email',
        body: 'Your email is not valid or not in the database',
      );
    }
  }

  Widget _body() {
    if (_internetConnection == false) {
      return Aesthetic.displayNoConnection();
    } else {
      if (_isLoading == true) {
        return Aesthetic.displayCircle();
      } else if (_showReload == true) {
        return Center(
          child: FloatingActionButton(
            foregroundColor: Colors.red,
            // backgroundColor: Colors.white,
            child: Icon(Icons.replay),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => LoginPage(
                    email: _emailController.text.trim(),
                    password: _passwordController.text.trim(),
                  ),
                ),
                (e) => false,
              );
            },
          ),
        );
      } else {
        return _displayLogin();
      }
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
              controller: _emailController,
              //decoration: new InputDecoration(labelText: 'email'),
              decoration: new InputDecoration(
                labelText: 'Email',
                errorText: _invalidemail ? 'Email Can\'t Be Empty' : null,
              ),
              onChanged: (String s) {
                print(s);
                setState(() {
                  _invalidemail = s.isEmpty ? true : false;
                });
              },
            ),
          ),
          ListTile(
            trailing: IconButton(
              // iconSize: 20.0,
              icon: Icon(
                Icons.remove_red_eye,
              ),

              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            ),
            title: new TextField(
              controller: _passwordController,
              decoration: new InputDecoration(
                labelText: 'Password',
                errorText: _invalidPassword ? 'Password Can\'t Be Empty' : null,
              ),
              onChanged: (String s) {
                print(s);
                setState(() {
                  _invalidPassword = s.isEmpty ? true : false;
                });
              },
              obscureText: _obscureText,
            ),
          ),
          ListTile(
            title: new TextButton(
                style: Theme.of(context).textButtonTheme.style,
                child:
                    new Text("Don\'t have an account? Tap here to register."),
                onPressed: () {
                  print("_createAccountPressed function");
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => RegisterPage()),
                      (e) => false);
                }),
          ),
          ListTile(
            title: new TextButton(
                style: Theme.of(context).textButtonTheme.style,
                child: new Text('Forgot Password?'),
                onPressed: () {
                  _passwordReset();
                }),
          ),
          ListTile(
            title: new ElevatedButton(
              style: Theme.of(context).elevatedButtonTheme.style,
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

  @override
  void initState() {
    _subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      print(result);
      if (result == ConnectivityResult.none) {
        setState(() {
          _internetConnection = false;
        });
      } else {
        setState(() {
          _internetConnection = true;
        });
      }
    });
    // _email.text = widget.email!.toString();
    //_password.text = widget.password!.toString();
    NotificationServices().initialize(context: context);
    _emailController.text =
        ((widget.email != null) ? widget.email.toString() : '');
    _passwordController.text =
        ((widget.password != null) ? widget.password.toString() : '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.white,
      child: SafeArea(
        top: true,
        bottom: true,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text("Login"),
            // backgroundColor: Colors.blue,
          ),
          drawer: buildDrawer(context, LoginPage.route),
          body: _body(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();
    _subscription.cancel();
    super.dispose();
  }

  @override
  void deactivate() {
    _subscription.cancel();
    super.deactivate();
  }
}
