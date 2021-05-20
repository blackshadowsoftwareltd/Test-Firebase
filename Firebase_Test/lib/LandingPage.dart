import 'package:Firebase_Test/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final CollectionReference userdataRef =
      FirebaseFirestore.instance.collection('Brand');
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapShot) {
          if (snapShot.hasError) {
            return Scaffold(body: Center(child: Text(snapShot.error)));
          }
          if (snapShot.connectionState == ConnectionState.done) {
            return HomePage();
          }
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        });
  }
}
