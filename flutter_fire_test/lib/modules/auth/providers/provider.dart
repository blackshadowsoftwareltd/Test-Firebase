import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_fire_test/helpers/controllers/txt_edtng.dart';
import 'package:flutter_fire_test/modules/auth/models/user.dart';
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

Future<bool> saveUserInfoAfterSignup(WidgetRef ref) async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;
    log(' id : ${user.uid}');
    final name = ref.read(txtEdtngCtrlProvider('Sign up Name')).text;
    final info = LocalUserInfo(name: name, uid: user.uid);
    final userCollection = FirebaseFirestore.instance
        .collection('UsersInFo')
        .doc(user.uid)
        .withConverter<LocalUserInfo>(
          fromFirestore: (snapshot, _) =>
              LocalUserInfo.fromMap(snapshot.data()!),
          toFirestore: (user, _) => user.toMap(),
        );

    final success = await userCollection.set(info).then((value) {
      log('User Saved in DB');
      return true;
    }).catchError((e) {
      log(e.toString());
      return false;
    });
    log(success.toString());
    return success;
  } catch (e) {
    return false;
  }
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
