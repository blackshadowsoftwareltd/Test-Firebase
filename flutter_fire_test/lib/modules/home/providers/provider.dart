import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
