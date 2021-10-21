import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

class User {
  String userId;

  User({this.userId});
}

class Authenticators {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  UserCredential result;

  User _userFormFirebaseUser(FirebaseUser user) {
    return user != null ? User(userId: user.uid) : null;
  }

  Future signInWithEmailAndPassword(String email, String pass) async {
    try {
      result = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: pass);
      FirebaseUser firebaseUser = result.user;
      return _userFormFirebaseUser(firebaseUser);
    } catch (e) {
      print(e);
    }
  }

  Future signUpWithEmailAndPassword(String email, String pass) async {
    try {
      result = await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: pass);
      FirebaseUser firebaseUser = result.user;
      return _userFormFirebaseUser(firebaseUser);
    } catch (e) {
      print(e);
    }
  }

  Future resetPassword(String _registerMail) async {
    try {
      return await firebaseAuth.sendPasswordResetEmail(email: _registerMail);
    } catch (e) {
      print(e);
    }
  }

  Future signOut() async {
    try {
      return await firebaseAuth.signOut();
    } catch (e) {
      print(e);
    }
  }
}
