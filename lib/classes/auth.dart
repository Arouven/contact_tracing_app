import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthenticate {
  //final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  void a() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print(user);
        print('User is currently signed out!');
      } else {
        print(user);
        print('User is signed in!');
      }
    });
  }

  void b() {
    FirebaseAuth.instance.idTokenChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
  }

  void firebaseSignIn({
    String email = 'aroupoolian@gmail.com',
    String password = '123456',
  }) async {
    //print('aaaaaaaaaaaaaaaaaaaaaaaaaaaa');
    //print(FirebaseAuth.instance.currentUser!.uid);
    //print('aaaaaaaaaaaaaaaaaaaaaaaaaaaa');
    try {
      print('in try');
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: "$email",
        password: "$password",
      );
      // print(FirebaseAuth.instance.currentUser!.uid);
      // String? userid = userCredential.user!.uid;
      // print(userid);

    } on FirebaseAuthException catch (e) {
      print(e.message);
      // if (e.code == 'weak-password') {
      //   print(e.message);
      // } else if (e.code == 'email-already-in-use') {
      //   print('The account already exists for that email.');
      // }
    } catch (e) {
      print('error in firebase');
      print(e);
    } finally {
      FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
      String? token = await _firebaseMessaging.getToken();
      print(token);
    }
  }
//   User _user(FirebaseUser firebaseUser) {
//     return firebaseUser != null ? User(uid: firebaseUser.uid) : null;
//   }

//   Future signInAnonymous() async {
//     try {
//       AuthResult authResult = await _firebaseAuth.signInAnonymously();
//       FirebaseUser firebaseUser = authResult.user;
//       return _user(firebaseUser);
//     } catch (e) {
//       print(e);
//       return null;
//     }
//   }

//   Future signInUsernamePassword(String email, String password) async {
//     try {
//       UserCredential userCredential =
//           await _firebaseAuth.createUserWithEmailAndPassword(
//         email: "$email",
//         password: "$password",
//       );
//     } on FirebaseAuthException catch (e) {
//       if (e.code == 'weak-password') {
//         print('The password provided is too weak.');
//       } else if (e.code == 'email-already-in-use') {
//         print('The account already exists for that email.');
//       }
//     } catch (e) {
//       print(e);
//     }
//   }
}


// // dynamic result=await _auth.signInAnon();
// // if(result==null){
// //   print('error signing in');
// // }
// // else{
// //   print(result.uid);
// // }