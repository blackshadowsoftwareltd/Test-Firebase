import 'package:E_comarce_Test/Screen/CartPage.dart';
import 'package:E_comarce_Test/constants.dart';
import 'package:E_comarce_Test/serivces/FirebaseServices.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomActionBar extends StatelessWidget {
  final String title;
  final bool hasTitle;
  final bool hasBackArrow;
  final bool hasBackGround;

  CustomActionBar(
      {this.title, this.hasTitle, this.hasBackArrow, this.hasBackGround});

  // getting cart value from database
  final CollectionReference _usersRef =
      FirebaseFirestore.instance.collection("Users");

  //getting data from FirebaseServices
  FireBaseServices _fireBaseServices = FireBaseServices();

  @override
  Widget build(BuildContext context) {
    bool _hasBackArrow = hasBackArrow ?? false;
    bool _hasTitle = hasTitle ?? true;
    bool _hasBackGround = hasBackArrow ?? false;

    return Container(
      padding: EdgeInsets.only(top: 30, bottom: 10, left: 10, right: 10),
      decoration: BoxDecoration(
        gradient: _hasBackGround
            ? null
            : LinearGradient(
                colors: [Colors.white, Colors.white.withOpacity(0)],
                begin: Alignment(0, 0),
                end: Alignment(0, 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_hasBackArrow)
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                height: 35,
                width: 35,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Icon(
                  Icons.arrow_back_ios_outlined,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          if (_hasTitle)
            Text(
              title ?? 'Custom Acton bar',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1),
            ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => CartPage()));
            },
            child: Container(
              height: 35,
              width: 35,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: StreamBuilder(
                stream: _usersRef
                    .doc(_fireBaseServices.getUserId())
                    .collection('Cart')
                    .snapshots(),
                builder: (context, snapShot) {
                  int _totalItems = 0;
                  if (snapShot.connectionState == ConnectionState.active) {
                    List _documents = snapShot.data.docs;
                    _totalItems = _documents.length;
                  }
                  return Text(
                    '$_totalItems' ?? '0',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 25),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
