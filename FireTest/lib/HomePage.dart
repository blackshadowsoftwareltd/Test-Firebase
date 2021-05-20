import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'SignIn.dart';

class HomePage extends StatefulWidget {
  //
  FirebaseUser user;

  HomePage({this.user});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Using FutureBuilder

  // Future getData() async {
  //   var fireStore = Firestore.instance;
  //   QuerySnapshot querySnapshot =
  //       await fireStore.collection('country').getDocuments();
  //   return querySnapshot.documents;
  // }

  @override
  Widget build(BuildContext context) {

    //sign out
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final GoogleSignIn googleSign = GoogleSignIn();
    void _signOut() {
      googleSign.signIn();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => SignIn()));
      print('User SignOut');
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('FireBase'),
      ),
      body: Center(
        child: Column(children: [
          Text(widget.user.email),
          Text(widget.user.displayName),
          Container(
            height: 100,
            width: 100,
            child: Image.network(widget.user.photoUrl),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: FlatButton(
              child: Text('Sign Out'),
              onPressed: () {
                _signOut();
              },
            ),
          )
        ]),
      ),

      // Using FutureBuilder

      // body: FutureBuilder(
      //   future: getData(),
      //   builder: (context, snapshot) {
      //     return ListView.builder(
      //         itemCount: snapshot.data.length,
      //         itemBuilder: (context, index) {
      //           DocumentSnapshot data = snapshot.data[index];
      //           return Card(
      //             child: ListTile(
      //               title: Text(data['name']),
      //             ),
      //           );
      //         });
      //   },
      // ),

      //Using StreamBuilder

      // body: StreamBuilder(
      //   stream: Firestore.instance.collection('country').snapshots(),
      //   builder: (_, snapShot) {
      //     if (!snapShot.hasData) {
      //       return Center(
      //         child: CircularProgressIndicator(),
      //       );
      //     } else {
      //       return GridView.builder(
      //           scrollDirection: Axis.vertical,
      //           itemCount: snapShot.data.documents.length,
      //           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      //               crossAxisCount: 2),
      //           itemBuilder: (_, index) {
      //             DocumentSnapshot data = snapShot.data.documents[index];
      //             return GridTile(
      //               child: Card(
      //                 child: Column(
      //                   crossAxisAlignment: CrossAxisAlignment.center,
      //                   children: [
      //                     Padding(
      //                       padding: const EdgeInsets.all(8.0),
      //                       child: Text(data['name']),
      //                     ),
      //                     Image.network(data['url'])
      //                   ],
      //                 ),
      //               ),
      //               // child: Image.asset(data['url']),
      //             );
      //           });
      //     }
      //   },
      // ),

      // Adding data to Firebase CloudStore

      // body: Center(
      //   child: RaisedButton(
      //     child: Text('Add'),
      //     onPressed: () {
      //       addData();
      //     },
      //   ),
      // ),
    );
  }

//Adding data to Firebase CloudStore
// Future addData() async {
//   final _dataBase = Firestore.instance
//       .collection('userInFo')
//       .add({'name': 'Razu', 'age': 21.toString(), 'height': '5.5'});
// }
}
