import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GetAllCartItems extends StatelessWidget {
  final bool textColor;
  final String collectionStr;

  GetAllCartItems({this.textColor, this.collectionStr});

  final CollectionReference userdataRef =
      FirebaseFirestore.instance.collection('UsersInFo');
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    bool _textColor = textColor ?? false;
    return StreamBuilder(
      stream: userdataRef
          .doc(_firebaseAuth.currentUser.uid)
          .collection(collectionStr)
          .snapshots(),
      builder: (context, snapShot) {
        int _totalItems = 0;
        if (snapShot.connectionState == ConnectionState.active) {
          List _documents = snapShot.data.docs;
          _totalItems = _documents.length;
          print(_totalItems);
        }
        return Text(
          '$_totalItems' ?? '0',
          style: TextStyle(
              fontSize: 20,
              color: _textColor ? Colors.white : Colors.black45,
              fontWeight: FontWeight.w600),
        );
      },
    );
  }
}
