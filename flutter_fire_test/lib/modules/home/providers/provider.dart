import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_fire_test/helpers/controllers/txt_edtng.dart';
import 'package:flutter_fire_test/modules/auth/models/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/*
final userStreamProvider = StreamProvider<User?>((ref) {
  // if(data!=null){
  //   return auth.userChanges().where((element) => element?.uid==data.uid);
  // }
  //  auth.userChanges();
// await  auth.currentUser?.reload();
  User? user;
  FirebaseAuth.instance.authStateChanges().listen((User? u) => user = u);
  print('state change ID : ${user?.uid}');
  FirebaseAuth.instance.userChanges().listen((User? u) => user = u);
  print('state change ID : ${user?.uid}');
  FirebaseAuth.instance.authStateChanges();
  return FirebaseAuth.instance.userChanges();
});
*/
final userStreamProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

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

final profileInfoProvider =
    AsyncNotifierProvider<_UserInfo, LocalUserInfo?>(_UserInfo.new);

class _UserInfo extends AsyncNotifier<LocalUserInfo?> {
  @override
  FutureOr<LocalUserInfo?> build() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;
    final docRef =
        FirebaseFirestore.instance.collection('UsersInFo').doc(user.uid);

    final docSnap = await docRef
        .withConverter<LocalUserInfo>(
          fromFirestore: (snapshot, _) =>
              LocalUserInfo.fromMap(snapshot.data()!),
          toFirestore: (user, _) => user.toMap(),
        )
        .get();
    return docSnap.data();
  }
}
