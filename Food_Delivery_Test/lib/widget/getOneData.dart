import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GetOneData extends StatelessWidget {
  final CollectionReference userdataRef =
      FirebaseFirestore.instance.collection('UsersInFo');
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: userdataRef.doc(_firebaseAuth.currentUser.uid).get(),
        builder: (context, snapShot) {
          if (snapShot.hasError) {
            return Text('Internet Connection Error',style: TextStyle(fontSize: 12),);
          }
          if (snapShot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data = snapShot.data.data();
            return Text('${data['userName']}',
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w400));
          }
          return Text('Loading...',
              style: TextStyle(fontSize: 16, color: Colors.white));
        });
  }
}
