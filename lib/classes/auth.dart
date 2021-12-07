// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class FirebaseAuthenticate {
//   final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
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
//           await FirebaseAuth.instance.createUserWithEmailAndPassword(
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
// }


// // dynamic result=await _auth.signInAnon();
// // if(result==null){
// //   print('error signing in');
// // }
// // else{
// //   print(result.uid);
// // }