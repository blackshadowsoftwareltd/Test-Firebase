import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_fire_test/helpers/controllers/txt_edtng.dart';
import 'package:flutter_fire_test/modules/home/providers/provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<bool> signup(WidgetRef ref) async {
  try {
    final credential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: ref.watch(txtEdtngCtrlProvider('Sign up Email')).text,
      password: ref.watch(txtEdtngCtrlProvider('Sign up Pass')).text,
    );
    log(credential.user?.uid.toString() ?? 'No UID');
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
