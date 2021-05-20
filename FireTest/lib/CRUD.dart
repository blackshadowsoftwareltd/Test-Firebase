import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CRUD extends StatefulWidget {
  @override
  _CRUDState createState() => _CRUDState();
}

class _CRUDState extends State<CRUD> {
  final DocumentReference documentReference =
      Firestore.instance.collection('userInFo').document('dammy');

  String _txt = null;

  StreamSubscription<DocumentSnapshot> subscription;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CRUD'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: RaisedButton(
              child: Text('Add'),
              onPressed: () {
                _add();
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: RaisedButton(
              child: Text('Update'),
              onPressed: () {
                _update();
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: RaisedButton(
              child: Text('Fatch'),
              onPressed: () {
                _fatch();
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: RaisedButton(
              child: Text('Delet'),
              onPressed: () {
                _delet();
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: _txt != null
                ? Text(_txt)
                : Center(
                    child: CircularProgressIndicator(),
                  ),
          )
        ],
      ),
    );
  }

  void _add() {
    Map<String, String> data = <String, String>{'name': 'Remon', 'age': '20'};
    documentReference.setData(data).whenComplete(() {
      print('data added');
    }).catchError((e) => print(e));
  }

  void _update() {
    Map<String, String> data = <String, String>{'name': 'Razu', 'age': '19'};
    documentReference.updateData(data).whenComplete(() {
      print('Updated');
    }).catchError((e) => print(e));
  }

  void _fatch() {
    documentReference.get().then((snapShot) {
      if (snapShot.exists) {
        setState(() {
          _txt = snapShot.data['name'];
        });
      }
    });
  }

  // for fatching
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    subscription = documentReference.snapshots().listen((snapShot) {
      if (snapShot.exists) {
        setState(() {
          _txt = snapShot.data['name'];
        });
      }
    });
  }
  
// for fatching
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    subscription.cancel();
  }

  void _delet() {
    documentReference.delete().whenComplete(() {
      print('Deleted');
      setState(() {});
    }).catchError((e) => print(e));
  }
}
