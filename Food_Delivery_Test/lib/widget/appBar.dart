import 'package:Food_Delivery_Test/screens/usersProfile.dart';
import 'package:Food_Delivery_Test/widget/getOneData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AppBars extends StatefulWidget {
  @override
  _AppBarsState createState() => _AppBarsState();
}

class _AppBarsState extends State<AppBars> {
  final CollectionReference userdataRef =
      FirebaseFirestore.instance.collection('UsersInFo');
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      color: Colors.green[400],
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UsersProfile()));
                  },
                  child: FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('UsersInFo')
                          .doc(_firebaseAuth.currentUser.uid)
                          .get(),
                      builder: (context, snapShot) {
                        if (snapShot.hasError) {
                          return CircleAvatar(
                            maxRadius: 20,
                            backgroundColor: Colors.green[600],
                            child: Icon(
                              Icons.person,
                              size: 25,
                              color: Colors.white,
                            ),
                          );
                        }

                        if (snapShot.connectionState == ConnectionState.done) {
                          Map<String, dynamic> data = snapShot.data.data();
                          String url='null';
                          url = data['profileImage'];
                          // print('>>>>>>>${data['profileImage']}');
                          if (url != 'null') {
                            return CircleAvatar(
                              maxRadius: 20,
                              backgroundImage:
                                  NetworkImage(data['profileImage']),
                            );
                          } else {
                            return CircleAvatar(
                              maxRadius: 20,
                              backgroundColor: Colors.green[600],
                              child: Icon(
                                Icons.person,
                                size: 25,
                                color: Colors.white,
                              ),
                            );
                          }
                        }

                        return CircleAvatar(
                          maxRadius: 20,
                          backgroundColor: Colors.green[600],
                          child: Icon(
                            Icons.person,
                            size: 25,
                            color: Colors.white,
                          ),
                        );
                      }),
                ),
              ),
              Padding(padding: EdgeInsets.all(5), child: GetOneData()),
              IconButton(
                  icon: Icon(
                    Icons.logout,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    _firebaseAuth.signOut();
                  }),
            ],
          ),
        ],
      ),
    );
  }
}
