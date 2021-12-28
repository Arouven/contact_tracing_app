import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthenticate {
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
    print('firebaseuid: ' + firebaseuid.toString());
    return firebaseuid;
  }

  Future<String?> getfirebasefcmtoken() async {
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    String? token = await _firebaseMessaging.getToken();
    print('fcmtoken: ' + token.toString());
    return token;
  }

  Future<bool> firebaseRegisterUser({
    required String email,
    required String password,
  }) async {
    try {
      print('in try');
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: "$email",
        password: "$password",
      );
      return true;
    } on FirebaseAuthException catch (e) {
      exception = e;
      print(e.message);
      return false;
    }
  }
}
