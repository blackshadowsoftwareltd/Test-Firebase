import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FireBaseServices {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  String getUserId() {
    return _firebaseAuth.currentUser.uid;
  }

  final CollectionReference productRef =
      FirebaseFirestore.instance.collection('Priducts');

  // User -> userId(document) ->Cart-> productId(document)
  final CollectionReference usersRef =
      FirebaseFirestore.instance.collection("Users");
}
