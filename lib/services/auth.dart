import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthenticate {
  //final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  // void a() {
  //   FirebaseAuth.instance.authStateChanges().listen((User? user) {
  //     if (user == null) {
  //       print(user);
  //       print('User is currently signed out!');
  //     } else {
  //       print(user);
  //       print('User is signed in!');
  //     }
  //   });
  // }

  // void b() {
  //   FirebaseAuth.instance.idTokenChanges().listen((User? user) {
  //     if (user == null) {
  //       print('User is currently signed out!');
  //     } else {
  //       print('User is signed in!');
  //     }
  //   });
  // }
  Future<bool?> emailExist({required String email}) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: "1234");
      return null;
    } on FirebaseAuthException catch (e) {
      print(e);
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        return false;
      } else {
        print('user exist');
        return true;
      }
    }
  }

  static late FirebaseAuthException exception;
  FirebaseAuthException geterrors() {
    return exception;
  }

  Future firebaseResetPassword({required String email}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return true;
    } on FirebaseAuthException catch (e) {
      exception = e;
      print(e);
      return false;
    }
  }

  Future<bool> firebaseLoginUser({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
    } on FirebaseAuthException catch (e) {
      exception = e;
      print(e);
      return false;
    }
  }

  String? getfirebaseuid() {
    String? firebaseuid = FirebaseAuth.instance.currentUser!.uid;
    print(firebaseuid);
    return firebaseuid;
  }

  Future<String?> getfirebasetoken() async {
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    String? token = await _firebaseMessaging.getToken();
    print(token);
    return token;
  }

  Future<bool> firebaseRegisterUser({
    required String email,
    required String password,
  }) async {
    //print('aaaaaaaaaaaaaaaaaaaaaaaaaaaa');
    //print(FirebaseAuth.instance.currentUser!.uid);
    //print('aaaaaaaaaaaaaaaaaaaaaaaaaaaa');
    try {
      print('in try');

      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: "$email",
        password: "$password",
      );

      return true;
      // print(FirebaseAuth.instance.currentUser!.uid);
      // String? userid = userCredential.user!.uid;
      // print(userid);

    } on FirebaseAuthException catch (e) {
      exception = e;
      print(e.message);
      return false;
      // if (e.code == 'weak-password') {
      //   print(e.message);
      // } else if (e.code == 'email-already-in-use') {
      //   print('The account already exists for that email.');
      // }
      // } catch (e) {
      //   print('error in firebase');
      //   print(e);
    }
    // finally {
    //   FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    //   String? token = await _firebaseMessaging.getToken();
    //   print(token);
    // }
  }
}
