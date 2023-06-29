import 'dart:developer' show log;

import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, FirebaseAuthException, User;
import '/helpers/controllers/txt_edtng.dart' show txtEdtngCtrlProvider;
import '/modules/home/providers/provider.dart'
    show saveUserInfoAfterSignup, userStreamProvider;
import 'package:flutter_riverpod/flutter_riverpod.dart' show WidgetRef;

Future<bool> signup(WidgetRef ref) async {
  try {
    final credential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: ref.watch(txtEdtngCtrlProvider('Sign up Email')).text,
      password: ref.watch(txtEdtngCtrlProvider('Sign up Pass')).text,
    );
    log(credential.user?.uid.toString() ?? 'No UID');

    await saveUserInfoAfterSignup(ref);
    await FirebaseAuth.instance.currentUser
        ?.reload(); //? to update the user stream (must need to reload)
    ref.invalidate(userStreamProvider);
    return true;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      log('The password provided is too weak.');
    } else if (e.code == 'email-already-in-use') {
      log('The account already exists for that email.');
    }
    return false;
  } catch (e) {
    log(e.toString());
    return false;
  }
}

Future<void> signout(WidgetRef ref) async {
  FirebaseAuth.instance.signOut();
  ref.invalidate(userStreamProvider);
}

Future<User?> signin(String email, String password) async {
  try {
    final credential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    return credential.user;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      log('No user found for that email.');
    } else if (e.code == 'wrong-password') {
      log('Wrong password provided for that user.');
    }
  }
  return null;
}
