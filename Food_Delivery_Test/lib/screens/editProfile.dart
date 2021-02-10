import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:toast/toast.dart';

import '../constants.dart';

class EditProfile extends StatefulWidget {
  final String userName, address, mail;
  final int contactNumber;

  EditProfile({this.address, this.mail, this.contactNumber, this.userName});

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final CollectionReference userdataRef =
      FirebaseFirestore.instance.collection('UsersInFo');

  String userName, address, mail;
  int contactNumber;
  bool isLoad = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit Profile'),backgroundColor: Colors.green[400],
        ),
        body: StreamBuilder<Object>(
            stream: null,
            builder: (context, snapshot) {
              return Stack(children: [
                Container(
                    // margin: EdgeInsets.only(top: 10),
                    child: ListView(children: [
                      Container(
                          height: 400,
                          alignment: Alignment.center,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                    height: 50,
                                    margin: EdgeInsets.all(10),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    decoration: BoxDecoration(
                                        color: Colors.green[200],
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    // color: Colors.yellow,
                                    child: TextField(
                                        decoration: InputDecoration(
                                            hintText: widget.userName),
                                        textAlign: TextAlign.start,
                                        style: Constants.ligntHeading,
                                        onChanged: (value) {
                                          userName = value;
                                        })),
                                Container(
                                    height: 50,
                                    margin: EdgeInsets.all(10),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    decoration: BoxDecoration(
                                        color: Colors.green[200],
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    // color: Colors.yellow,
                                    child: TextField(
                                        decoration: InputDecoration(
                                            hintText: widget.contactNumber
                                                .toString()),
                                        textAlign: TextAlign.start,
                                        style: Constants.ligntHeading,
                                        keyboardType: TextInputType.number,
                                        onChanged: (value) {
                                          contactNumber = int.parse(value);
                                        })),
                                Container(
                                    height: 50,
                                    margin: EdgeInsets.all(10),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    decoration: BoxDecoration(
                                        color: Colors.green[200],
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    // color: Colors.yellow,
                                    child: TextField(
                                        decoration: InputDecoration(
                                            hintText: widget.address),
                                        textAlign: TextAlign.start,
                                        style: Constants.ligntHeading,
                                        onChanged: (value) {
                                          address = value;
                                        }))
                              ])),
                      Container(
                          height: 115,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                if (isLoad == true) CircularProgressIndicator(),
                                GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isLoad = true;
                                      });
                                      dataChecking(
                                          userName, contactNumber, address);
                                      print('dataChecking is load.........');

                                      isLoad = false;
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                        margin: EdgeInsets.all(5),
                                        height: 55,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        alignment: Alignment.center,
                                        // color: Colors.green[400],
                                        decoration: BoxDecoration(
                                            color: Colors.green[400],
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Text('Save and Exit',
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white))))
                              ]))
                    ]))
              ]);
            }));
  }

  void dataChecking(String name, int phone, String uAddress) {
    String userName = name ?? widget.userName;
    int contactNumber = phone ?? widget.contactNumber;
    String address = uAddress ?? widget.address;
    if (userName == null) {
      showToast('Enter your Name',
          duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
    } else if (contactNumber == null) {
      showToast('Enter your Contact Number',
          duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
    } else if (address == null) {
      showToast('Enter your Address',
          duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
    } else {
      print('name: $userName phoneNumber: $contactNumber address: $address');
      dataUpdating(userName, contactNumber, address);
      print('dataUpdating is load..........');
    }
  }

  Future dataUpdating(String name, int phone, String address) async {
    return await userdataRef.doc(_firebaseAuth.currentUser.uid).update({
      'userName': name,
      'contactNumber': phone,
      'address': address,
    });
  }

  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }
}
